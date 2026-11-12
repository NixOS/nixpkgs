{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,
  python,
  cudaPackages,

  # nativeBuildInputs
  autoPatchelfHook,

  # dependencies
  cuda-bindings,
  cuda-pathfinder,
  numpy,
  pyelftools,
}:

let
  inherit (stdenv.hostPlatform) system;

  version = "13.5.0";

  platforms = {
    x86_64-linux = "manylinux_2_24_x86_64.manylinux_2_28_x86_64";
    aarch64-linux = "manylinux_2_24_aarch64.manylinux_2_28_aarch64";
  };

  hashes = {
    x86_64-linux = {
      cp311 = "sha256-UJMwxdUm1OheKK0QBqawBnOqavYA2muR9V4Dx7djcY8=";
      cp312 = "sha256-yORgEGqttxzK08TGWfk6R3Iy+DTXR01/7bVhBI29a3g=";
      cp313 = "sha256-Q/SEsCaK6BlpB3xp8oZrVTzHQ7sIVVi8T62CqlqJeKo=";
      cp314 = "sha256-DGMpsgHxKBQaMgkuQf6VNJkYVHLLmsVlyqjQJNLF5/8=";
    };
    aarch64-linux = {
      cp311 = "sha256-40/FGLO3mZiD5tm4pB5EFbhUw+JMnRnRAW8nRyVMSgE=";
      cp312 = "sha256-fusnd0Q2p5vBqg5oFjp4QXdBvUx4qKAwI36zbC2lFSw=";
      cp313 = "sha256-KN3Trbf4ekYybFs3U5W57MzyLK2uNAleHajfhgo41wA=";
      cp314 = "sha256-Xmibh1CpFTqCGPSa2S5kp518B++Qm/YRBoefXCEfHOg=";
    };
  };

  # Every wheel, keyed "<system>-<cpXY>" and exposed as passthru.srcs so the update script refreshes every hash.
  srcs = lib.concatMapAttrs (
    wheelSystem:
    lib.mapAttrs' (
      pyTag: hash:
      lib.nameValuePair "${wheelSystem}-${pyTag}" (fetchPypi {
        pname = "cupti_python";
        inherit version hash;
        format = "wheel";
        platform = platforms.${wheelSystem};
        dist = pyTag;
        python = pyTag;
        abi = pyTag;
      })
    )
  ) hashes;

  srcKey = "${system}-cp${lib.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
in
buildPythonPackage (finalAttrs: {
  pname = "cupti-python";
  inherit version;
  format = "wheel";

  src = srcs.${srcKey} or (throw "cupti-python: no wheel for ${srcKey}");

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    (lib.getLib cudaPackages.cuda_cupti)
    (lib.getLib stdenv.cc.cc)
  ];

  pythonRemoveDeps = [
    # Provided by cudaPackages.cuda_cupti instead of the nvidia-cuda-cupti wheel.
    "nvidia-cuda-cupti"
  ];
  dependencies = [
    cuda-bindings
    cuda-pathfinder
    numpy
    pyelftools
  ];

  # The extension finds libcupti at run time with cuda.pathfinder's load_nvidia_dynamic_lib("cupti"), which
  # searches pip wheel and conda layouts, CUDA_HOME and the dynamic linker's default paths, but first returns a copy
  # that is already loaded. Link libcupti into the loader extension so autoPatchelfHook puts cuda_cupti on its
  # RUNPATH and it's loaded together with the module.
  preFixup = ''
    for so in "$out/${python.sitePackages}"/cupti/_internal/cupti.*.so; do
      patchelf --add-needed libcupti.so.${cudaPackages.cudaMajorVersion} "$so"
    done
  '';

  pythonImportsCheck = [
    "cupti"
    "cupti.cupti"
  ];

  # No python tests
  doCheck = false;

  passthru = {
    inherit srcs;

    updateScript = nix-update-script {
      extraArgs = [
        "--url=mirror://pypi/c/cupti-python/"
        # The wheels' fetchers carry no position, so name the file their hashes live in.
        "--override-filename=pkgs/development/python-modules/cupti-python/default.nix"
        "--no-src"
      ]
      ++ lib.concatMap (name: [
        "--subpackage"
        "srcs.${name}"
      ]) (lib.attrNames srcs);
    };

    # Runs the vector-add sample shipped in the wheel: it compiles a kernel with NVRTC, launches it under CUPTI activity
    # tracing, prints the activity records and verifies the result.
    testers.cuda.vectorAddDrv =
      cudaPackages.writeGpuTestPython
        {
          name = "cupti-python-vector-add-drv";
          libraries = ps: [ ps.cupti-python ];
        }
        ''
          import pathlib
          import subprocess
          import sys

          import cupti

          sample = pathlib.Path(cupti.__file__).parent.parent / "cupti-python-samples" / "CuptiVectorAddDrv.py"
          result = subprocess.run([sys.executable, sample, "--profile"], capture_output=True, text=True)
          print(result.stdout)
          print(result.stderr, file=sys.stderr)

          assert result.returncode == 0, f"{sample.name} exited with {result.returncode}"
          assert "verify_result: PASS" in result.stdout, "vector add produced wrong results"
          kinds = {line.split()[0] for line in result.stdout.splitlines() if line.strip()}
          assert "CONCURRENT_KERNEL" in kinds, "CUPTI recorded no kernel activity"
        '';
    tests.cuda.vectorAddDrv = finalAttrs.passthru.testers.cuda.vectorAddDrv.gpuCheck;
  };

  meta = {
    description = "Python APIs for the NVIDIA CUDA Profiling Tools Interface (CUPTI)";
    homepage = "https://docs.nvidia.com/cupti-python/";
    changelog = "https://docs.nvidia.com/cupti-python/${finalAttrs.version}/release-notes/release-notes.html";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.nvidiaCuptiPython;
    maintainers = with lib.maintainers; [
      GaetanLepage
      connorbaker
    ];
    teams = [ lib.teams.cuda ];
    platforms = lib.attrNames platforms;
    # The wheels require nvidia-cuda-cupti~=13.4 and load libcupti.so.13.
    broken = cudaPackages.cudaOlder "13.4" || cudaPackages.cudaAtLeast "14";
  };
})
