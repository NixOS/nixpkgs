{
  autoAddDriverRunpath,
  cmake,
  cudaPackages,
  fetchFromGitHub,
  fetchpatch,
  lib,
}:
cudaPackages.backendStdenv.mkDerivation (finalAttrs: {
  pname = "xmrig-cuda-mo";
  version = "6.22.1-mo1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "MoneroOcean";
    repo = "xmrig-cuda";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O6VFZUuCrR2/or4BZQaqBXcmHMCbeCNqyvSKJ0Pef/Y=";
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
    substituteInPlace src/cuda_cryptonight_gpu.hpp \
      --replace-fail 'int_as_float' '__int_as_float' \
      --replace-fail 'int2float' '__int2float_rn' \
      --replace-fail 'float_as_int' '__float_as_int'
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
    description = "Fork of the XMRig CPU miner (CUDA plugin) with support for algorithm switching";
    homepage = "https://github.com/MoneroOcean/xmrig-cuda";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      albertlarsan68
    ];
  };
})
