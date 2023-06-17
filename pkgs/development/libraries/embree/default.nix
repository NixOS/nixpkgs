{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, ispc, tbb, glfw,
  openimageio, libjpeg, libpng, libpthreadstubs, libX11, glib }:

stdenv.mkDerivation rec {
  pname = "embree";
  version = "3.13.5";

  src = fetchFromGitHub {
    owner = "embree";
    repo = "embree";
    rev = "v${version}";
    sha256 = "sha256-tfM4SGOFVBG0pQK9B/iN2xDaW3yjefnTtsoUad75m80=";
  };

  postPatch = ''
    # Fix duplicate /nix/store/.../nix/store/.../ paths
    sed -i "s|SET(EMBREE_ROOT_DIR .*)|set(EMBREE_ROOT_DIR $out)|" \
      common/cmake/embree-config.cmake
    sed -i "s|$""{EMBREE_ROOT_DIR}/||" common/cmake/embree-config.cmake
    substituteInPlace common/math/math.h --replace 'defined(__MACOSX__) && !defined(__INTEL_COMPILER)' 0
    substituteInPlace common/math/math.h --replace 'defined(__WIN32__) || defined(__FreeBSD__)' 'defined(__WIN32__) || defined(__FreeBSD__) || defined(__MACOSX__)'
  '';

  cmakeFlags = [
    "-DEMBREE_TUTORIALS=OFF"
    "-DEMBREE_RAY_MASK=ON"
    "-DTBB_ROOT=${tbb}"
    "-DTBB_INCLUDE_DIR=${tbb.dev}/include"
  ];


  nativeBuildInputs = [ ispc pkg-config cmake ];
  buildInputs = [ tbb glfw openimageio libjpeg libpng libX11 libpthreadstubs ]
                ++ lib.optionals stdenv.isDarwin [ glib ];

  meta = with lib; {
    description = "High performance ray tracing kernels from Intel";
    homepage = "https://embree.github.io/";
    maintainers = with maintainers; [ hodapp gebner ];
    license = licenses.asl20;
    platforms = platforms.unix;
    badPlatforms = [ "aarch64-linux" ];
  };
}
