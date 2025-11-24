{
  _cuda,
  backendStdenv,
  cuda_cudart,
  cuda_nvcc,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  fetchFromGitHub,
  flags,
  lib,
  # passthru.updateScript
  gitUpdater,
}:
let
  inherit (_cuda.lib) _mkMetaBadPlatforms;
  inherit (lib) licenses maintainers teams;
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "gdrcopy";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "gdrcopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2cDsDc1lGW9rNF1q3EhjmiJhNaIwuFYlNdooPe7/R2I=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [
    cuda_nvcc
  ];

  postPatch = ''
    nixLog "patching shebang in $PWD/config_arch"
    patchShebangs "$PWD/config_arch"

    nixLog "patching awk expression in $PWD/Makefile"
    substituteInPlace "$PWD/Makefile" \
      --replace-fail \
        "/\#" \
        "/#" \
      --replace-fail \
        'lib64' \
        'lib'

    nixLog "patching $PWD/src/Makefile"
    substituteInPlace "$PWD/src/Makefile" \
      --replace-fail \
        "/\#" \
        "/#"

    nixLog "patching $PWD/tests/Makefile"
    substituteInPlace "$PWD/tests/Makefile" \
      --replace-fail \
        'CUDA_VERSION := $(shell $(GET_CUDA_VERSION) $(NVCC))' \
        'CUDA_VERSION := ${cudaMajorMinorVersion}' \
      --replace-fail \
        'NVCCFLAGS ?= $(shell $(GET_CUDA_GENCODE) $(NVCC)) $(NVCC_STD)' \
        'NVCCFLAGS ?= ${flags.gencodeString} $(NVCC_STD)' \
      --replace-fail \
        'lib64' \
        'lib'
  '';

  enableParallelBuilding = true;

  buildInputs = [
    cuda_cudart
  ];

  buildFlags = [
    # Makefile variables which must be set explicitly
    "CUDA=${lib.getLib cuda_cudart}"
    "NVCC=${lib.getExe cuda_nvcc}" # TODO: shoud be using cuda_nvcc from pkgsBuildHost

    # Make targets
    # NOTE: We cannot use `all` because it includes the driver, which needs the driver source code.
    "lib"
    "exes"
  ];

  # Tests require gdrdrv be installed (don't know how to communicate dependency on the driver).
  doCheck = false;

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "prefix=/"
  ];

  passthru.updateScript = gitUpdater {
    inherit (finalAttrs) pname version;
    rev-prefix = "v";
  };

  meta = {
    description = "Fast GPU memory copy library based on NVIDIA GPUDirect RDMA technology";
    homepage = "https://github.com/NVIDIA/gdrcopy";
    license = licenses.mit;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = [ maintainers.connorbaker ];
    teams = [ teams.cuda ];
  };
})
