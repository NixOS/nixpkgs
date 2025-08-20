{
  autoAddDriverRunpath,
  backendStdenv,
  cmake,
  cudatoolkit,
  cudaVersion,
  fetchFromGitHub,
  fetchpatch,
  freeimage,
  glfw3,
  hash,
  lib,
  pkg-config,
  stdenv,
}:
let
  inherit (lib) lists strings;
in
backendStdenv.mkDerivation (finalAttrs: {
  strictDeps = true;

  pname = "cuda-samples";
  version = cudaVersion;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cuda-samples";
    rev = "v${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs =
    [
      autoAddDriverRunpath
      pkg-config
    ]
    # CMake has to run as a native, build-time dependency for libNVVM samples.
    # However, it's not the primary build tool -- that's still make.
    # As such, we disable CMake's build system.
    ++ lists.optionals (strings.versionAtLeast finalAttrs.version "12.2") [ cmake ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    cudatoolkit
    freeimage
    glfw3
  ];

  # See https://github.com/NVIDIA/cuda-samples/issues/75.
  patches = lib.optionals (finalAttrs.version == "11.3") [
    (fetchpatch {
      url = "https://github.com/NVIDIA/cuda-samples/commit/5c3ec60faeb7a3c4ad9372c99114d7bb922fda8d.patch";
      hash = "sha256-0XxdmNK9MPpHwv8+qECJTvXGlFxc+fIbta4ynYprfpU=";
    })
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    export CUDA_PATH=${cudatoolkit}
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin bin/${stdenv.hostPlatform.parsed.cpu.name}/${stdenv.hostPlatform.parsed.kernel.name}/release/*

    runHook postInstall
  '';

  meta = {
    description = "Samples for CUDA Developers which demonstrates features in CUDA Toolkit";
    # CUDA itself is proprietary, but these sample apps are not.
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ obsidian-systems-maintenance ] ++ lib.teams.cuda.members;
  };
})
