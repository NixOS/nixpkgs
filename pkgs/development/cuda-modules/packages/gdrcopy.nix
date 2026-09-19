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
  removeReferencesTo,
  # passthru.updateScript
  gitUpdater,
}:
let
  # Compiler paths embedded in strings bypass nativeBuildInputs splicing.
  buildNvcc = cuda_nvcc.__spliced.buildHost or cuda_nvcc;
  inherit (_cuda.lib) _mkMetaBadPlatforms;
  inherit (lib) licenses maintainers teams;
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "gdrcopy";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "gdrcopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Waq/Of0LcLDqyaWaU47lorJcG30CijcdTsvf9nMqgrg=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [
    cuda_nvcc
    removeReferencesTo
  ];

  postPatch = ''
    # The upstream probe compiles and executes a program. Preprocessing its
    # own architecture header asks the HOST compiler without running HOST code.
    cat > config_arch <<'SH'
    #!${backendStdenv.shell}
    set -euo pipefail
    "$CC" -dM -E -include "$(dirname "$0")/include/gdrconfig.h" - </dev/null |
      sed -n 's/^#define GDRAPI_\(.*\) .*/\1/p'
    SH

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
        "/#" \
      --replace-fail \
        'PATH=/sbin:/usr/sbin:$$PATH; ldconfig -n $(PWD)' \
        ""

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

  makeFlags = [
    "CUDA=${lib.getLib cuda_cudart}"
    "NVCC=${lib.getExe buildNvcc}"
  ];

  buildFlags = [
    # NOTE: We cannot use `all` because it includes the driver, which needs the driver source code.
    "lib"
    "exes"
  ];

  # Since CUDA 13, gdrcopy_pplat -- the only test built with relocatable device code -- embeds the
  # nvlink command line, naming the store paths of both nvcc and the cudart supplying cudadevrt.
  # Neither is needed at runtime: no binary here has libcudart in DT_NEEDED, and libcuda.so.1 comes
  # from the driver. Same leak as nccl's; see https://github.com/NixOS/nixpkgs/pull/457803
  postFixup = ''
    remove-references-to \
      -t "${lib.getBin buildNvcc}" \
      -t "${lib.getLib cuda_cudart}" \
      "$out"/bin/*
  '';

  # C.f. remove-references-to above. Ensure *all* such references are removed.
  disallowedRequisites = [
    (lib.getBin buildNvcc)
    (lib.getLib cuda_cudart)
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
