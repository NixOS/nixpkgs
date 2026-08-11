{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  einops,
  hjson,
  msgpack,
  ninja,
  numpy,
  cupy,
  cutlass,
  packaging,
  psutil,
  py-cpuinfo,
  pydantic,
  torch,
  tqdm,
  nix-update-script,
  cudaPackages,
  symlinkJoin,
}:

let
  cudaVersion = cudaPackages.cudaMajorMinorVersion;

  inherit (torch) cudaCapabilities cudaSupport;

  cuda-native-redist = symlinkJoin {
    name = "cuda-native-redist-${cudaVersion}";
    paths = with cudaPackages; [
      (lib.getDev cuda_cudart)
      (lib.getLib cuda_cudart)
      (lib.getStatic cuda_cudart)
      cuda_nvcc
    ];
  };

in

buildPythonPackage (finalAttrs: {
  pname = "deepspeed";
  version = "0.19.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deepspeedai";
    repo = "DeepSpeed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nw1rw65hdqhARFR7W+XmmRT/pLkCi5nTF+6R9L3bLyo=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    einops
    hjson
    msgpack
    ninja
    numpy
    packaging
    psutil
    py-cpuinfo
    pydantic
    setuptools
    torch
    tqdm
  ]
  ++ lib.optionals cudaSupport [
    cutlass
    cupy
  ];

  postPatch = ''
    substituteInPlace deepspeed/ops/op_builder/builder.py \
      --replace-fail 'import distutils' 'import setuptools._distutils'
  ''
  + lib.optionalString cudaSupport ''
    # Hardcode CUDA_HOME to nix store path for JIT op compilation at runtime
    substituteInPlace deepspeed/ops/op_builder/builder.py \
      --replace-fail \
        "cuda_home = torch.utils.cpp_extension.CUDA_HOME" \
        "cuda_home = '${cuda-native-redist}'"

    # Hardcode CUTLASS_PATH to nix store path
    substituteInPlace deepspeed/ops/op_builder/evoformer_attn.py \
      --replace-fail \
        "self.cutlass_path = os.environ.get(\"CUTLASS_PATH\")" \
        "self.cutlass_path = '${cutlass}'"
  '';

  env = lib.optionalAttrs cudaSupport {
    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" cudaCapabilities;
  };

  preConfigure = ''
    # setuptools writes to ~/.cache during builds
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [
    "deepspeed"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Deep learning optimization library that makes distributed training and inference easy, efficient, and effective.";
    homepage = "https://www.deepspeed.ai/";
    changelog = "https://github.com/deepspeedai/DeepSpeed/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
