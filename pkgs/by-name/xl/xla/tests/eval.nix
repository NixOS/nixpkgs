# Run with: nix-instantiate --eval --strict pkgs/by-name/xl/xla/tests/eval.nix --arg nixpkgs ./.
# Keep the independent free-only import outside passthru to avoid recursive
# package-set evaluation in a build or test-discovery traversal.
{ nixpkgs }:
let
  free = import nixpkgs {
    config = {
      allowUnfree = false;
      allowUnfreePredicate = _: false;
      cudaSupport = false;
    };
  };
  unfree = import nixpkgs { config.allowUnfree = true; };
  cpu = free.xla.override { cudaSupport = false; };
  gpu = unfree.xla.override { cudaSupport = true; };
  rejected = builtins.tryEval ((free.xla.override { cudaSupport = true; }).drvPath);
  configured =
    capabilities: forwardCompat:
    (import nixpkgs {
      config = {
        allowUnfree = true;
        cudaCapabilities = capabilities;
        cudaForwardCompat = forwardCompat;
      };
    }).xla.override
      { cudaSupport = true; };
  forward = configured [ "8.0" "8.9" ] true;
  noForward = configured [ "8.0" "8.9" ] false;
  ordered = configured [ "9.0" "8.0" ] true;
  accelerated = configured [ "9.0a" ] true;
  familyRejected = forwardCompat: builtins.tryEval (configured [ "10.0f" ] forwardCompat).drvPath;
  selected = gpu.override { cudaPackages = unfree.cudaPackages_12_8; };
  selectedWithHash = selected.overrideAttrs (previousAttrs: {
    deps = previousAttrs.deps.overrideAttrs {
      outputHash = unfree.lib.fakeHash;
      outputHashAlgo = "sha256";
    };
  });
  selectedExpected = unfree.callPackage ./default.nix {
    xla = selectedWithHash;
    cudaSupport = true;
    cudaPackages = unfree.cudaPackages_12_8;
  };
  selectedConfigureOverride = builtins.tryEval selectedWithHash.tests.cuda.configureOverride.drvPath;
  hasCapabilities =
    value: package: unfree.lib.hasInfix "--cuda_compute_capabilities=${value} \\" package.preConfigure;
  containsPath =
    path: text:
    unfree.lib.hasInfix (builtins.unsafeDiscardStringContext (toString path)) (
      builtins.unsafeDiscardStringContext text
    );
  hasCompiledDefault =
    root: package:
    unfree.lib.hasInfix ''opts.set_xla_gpu_cuda_data_dir("${builtins.unsafeDiscardStringContext (toString root)}");'' (
      builtins.unsafeDiscardStringContext package.postConfigure
    );
  overridden = cpu.overrideAttrs (previousAttrs: {
    postInstall = (previousAttrs.postInstall or "") + ''touch "$out/override-linkage-test"'';
    passthru = previousAttrs.passthru // {
      overrideLinkageSentinel = true;
    };
  });
  expected = unfree.callPackage ./default.nix {
    xla = overridden;
    cudaSupport = false;
  };
  gpuOverridden = gpu.overrideAttrs { postInstall = ''touch "$out/override-linkage-test"''; };
  gpuExpected = unfree.callPackage ./default.nix {
    xla = gpuOverridden;
    cudaSupport = true;
  };
in
assert (builtins.tryEval cpu.drvPath).success;
assert !rejected.success;
assert builtins.all (license: license.free) cpu.meta.license;
assert builtins.elem unfree.lib.licenses.nvidiaCudaRedist gpu.meta.license;
assert builtins.all (
  license: builtins.elem license gpu.meta.license
) unfree.cudaPackages.cudnn.meta.license;
assert cpu.tests.cuda == { } && cpu.testers.cuda == { };
assert gpu.tests.cuda.pjrt.requiredSystemFeatures == [ "cuda" ];
assert gpu.tests.cuda.hlo.requiredSystemFeatures == [ "cuda" ];
assert gpu.tests.cuda.nccl.requiredSystemFeatures == [ "cuda" ];
assert gpu.tests.cuda.install.requiredSystemFeatures == [ ];
assert gpu.tests.cuda.configure.requiredSystemFeatures == [ "big-parallel" ];
assert gpu.tests.cuda.configureOverride.requiredSystemFeatures == [ "big-parallel" ];
assert gpu.tests.cuda.configure.deps.drvPath == gpu.deps.drvPath;
assert noForward.tests.cuda.configure.deps.drvPath == noForward.deps.drvPath;
assert gpu.tests.cuda.configure.passthru == { };
assert hasCapabilities "sm_75,sm_80,sm_86,sm_89,sm_90,sm_100,sm_103,sm_120,compute_121" gpu;
assert hasCapabilities "sm_80,compute_89" forward;
assert hasCapabilities "sm_80,sm_89" noForward;
assert hasCapabilities "sm_90,compute_80" ordered;
assert hasCapabilities "compute_90a" accelerated;
assert hasCapabilities "sm_75,sm_80,sm_86,sm_89,sm_90,sm_100,compute_120" selected;
assert !(familyRejected false).success && !(familyRejected true).success;
assert unfree.lib.hasInfix "--cuda_version=12.9.1" gpu.preConfigure;
assert unfree.lib.hasInfix "--cudnn_version=9.22.0" gpu.preConfigure;
assert hasCompiledDefault unfree.cudaPackages.cuda_nvcc gpu;
assert !(containsPath unfree.cudaPackages.cuda_nvcc cpu.postConfigure);
assert !(builtins.tryEval selected.drvPath).success;
assert (builtins.tryEval selectedWithHash.drvPath).success;
assert selectedConfigureOverride.success;
assert selectedWithHash.tests.cuda.configureOverride.deps.drvPath == selectedWithHash.deps.drvPath;
assert selectedWithHash.testers.cuda.pjrt.drvPath == selectedExpected.testers.cuda.pjrt.drvPath;
assert unfree.lib.hasInfix "--cuda_version=12.8.1" selectedWithHash.preConfigure;
assert hasCompiledDefault unfree.cudaPackages_12_8.cuda_nvcc selectedWithHash;
assert forward.deps.outPath == gpu.deps.outPath;
assert noForward.deps.outPath == gpu.deps.outPath;
assert forward.deps.outputHash == gpu.deps.outputHash;
assert noForward.deps.outputHash == gpu.deps.outputHash;
assert overridden.drvPath != cpu.drvPath;
assert overridden.deps.drvPath == cpu.deps.drvPath;
assert overridden.overrideLinkageSentinel;
assert overridden.tests.cpu.drvPath == expected.tests.cpu.drvPath;
assert overridden.tests.hlo.drvPath == expected.tests.hlo.drvPath;
assert overridden.tests.install.drvPath == expected.tests.install.drvPath;
assert gpuOverridden.tests.cuda.pjrt.drvPath == gpuExpected.tests.cuda.pjrt.drvPath;
assert gpuOverridden.tests.cuda.nccl.drvPath == gpuExpected.tests.cuda.nccl.drvPath;
assert gpuOverridden.tests.cuda.hlo.drvPath == gpuExpected.tests.cuda.hlo.drvPath;
{
  cpuChecks = builtins.mapAttrs (_: check: check.drvPath) (builtins.removeAttrs cpu.tests [ "cuda" ]);
  cpuTesters = builtins.mapAttrs (_: tester: tester.meta.mainProgram) (
    builtins.removeAttrs cpu.testers [ "cuda" ]
  );
  cpuDrvPath = cpu.drvPath;
  cudaDrvPath = gpu.drvPath;
  unfreeRejected = !rejected.success;
  capabilitiesAndOverrideLinkage = true;
  cudaDepsDrvPath = gpu.deps.drvPath;
  cudaConfigureChecks = {
    default = gpu.tests.cuda.configure.drvPath;
    noForward = noForward.tests.cuda.configure.drvPath;
    override = gpu.tests.cuda.configureOverride.drvPath;
  };
}
