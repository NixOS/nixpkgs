{
  autoAddDriverRunpath,
  cmake,
  cudaPackages,
  fetchFromGitHub,
  fetchpatch,
  lib,
}:
cudaPackages.backendStdenv.mkDerivation (finalAttrs: {
  pname = "xmrig-cuda";
  version = "6.22.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig-cuda";
    tag = "v${finalAttrs.version}";
    hash = "sha256-krS0ygKclXDLti24PDnBFUetOAYkYM8jty4C3PSOEWY=";
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/xmrig/xmrig-cuda/commit/5947ae05f87eb7966fbe0ad2db149a496f908e87.patch";
      hash = "sha256-5fxlc09DnJ2uNZAdhYdLv67RHCha7+SfMg9XzwwrN9o=";
    })
    (fetchpatch {
      url = "https://github.com/xmrig/xmrig-cuda/commit/d0065c315779b28f12944a74694f81e13fb01ece.patch";
      hash = "sha256-8lU3s2b1eh7fvcMze/FIiaURFrkypVGJisrE7w0aDM4=";
    })
  ];
  postPatch = ''
    substituteInPlace cmake/flags.cmake \
      --replace-fail 'set(CMAKE_CXX_STANDARD 11)' 'set(CMAKE_CXX_STANDARD 17)' \
      --replace-fail '-std=c++11' '-std=c++17'
  '';

  cmakeFlags = [
    "-DLIBCUDA_LIBRARY_DIR=${lib.getLib cudaPackages.cuda_cudart}/lib/stubs/"
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
    cmake
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_nvrtc
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
  ];

  installPhase = ''
    runHook preInstall

    install -vD libxmrig-cuda.so $out/lib/libxmrig-cuda.so

    runHook postInstall
  '';

  meta = {
    description = "Monero (XMR) CPU miner, CUDA plugin";
    homepage = "https://github.com/xmrig/xmrig-cuda";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      albertlarsan68
    ];
  };
})
