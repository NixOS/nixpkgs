{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ispc,
  tbb,
  glfw,
  openimageio,
  libjpeg,
  libpng,
  libpthreadstubs,
  libX11,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "embree";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "embree";
    repo = "embree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bHVokEfnTW2cJqx3Zz2x1hIH07WamPAVFY9tiv6nHd0=";
  };

  postPatch = ''
    # Fix duplicate /nix/store/.../nix/store/.../ paths
    sed -i "s|SET(EMBREE_ROOT_DIR .*)|set(EMBREE_ROOT_DIR $out)|" \
      common/cmake/embree-config.cmake
    sed -i "s|$""{EMBREE_ROOT_DIR}/||" common/cmake/embree-config.cmake
    substituteInPlace common/math/emath.h --replace 'defined(__MACOSX__) && !defined(__INTEL_COMPILER)' 0
    substituteInPlace common/math/emath.h --replace 'defined(__WIN32__) || defined(__FreeBSD__)' 'defined(__WIN32__) || defined(__FreeBSD__) || defined(__MACOSX__)'
  '';

  cmakeFlags = [
    "-DEMBREE_TUTORIALS=OFF"
    "-DEMBREE_RAY_MASK=ON"
    "-DTBB_ROOT=${tbb}"
    "-DTBB_INCLUDE_DIR=${tbb.dev}/include"
  ];

  nativeBuildInputs = [
    ispc
    pkg-config
    cmake
  ];
  buildInputs = [
    tbb
    glfw
    openimageio
    libjpeg
    libpng
    libX11
    libpthreadstubs
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ glib ];

  meta = {
    description = "High performance ray tracing kernels from Intel";
    homepage = "https://embree.github.io/";
    maintainers = with lib.maintainers; [
      hodapp
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
