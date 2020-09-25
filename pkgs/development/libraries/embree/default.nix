{ stdenv, fetchFromGitHub, cmake, pkgconfig, ispc, tbb, glfw,
  openimageio, libjpeg, libpng, libpthreadstubs, libX11 }:

stdenv.mkDerivation rec {
  pname = "embree";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "embree";
    repo = "embree";
    rev = "v${version}";
    sha256 = "0v5gqi8jp09xxcbyyknji83412bq4l0w35b6hnrqxycgdrnf7hkr";
  };

  postPatch = ''
    # Fix duplicate /nix/store/.../nix/store/.../ paths
    sed -i "s|SET(EMBREE_ROOT_DIR .*)|set(EMBREE_ROOT_DIR $out)|" \
      common/cmake/embree-config.cmake
    sed -i "s|$""{EMBREE_ROOT_DIR}/||" common/cmake/embree-config.cmake
  '';

  cmakeFlags = [
    "-DEMBREE_TUTORIALS=OFF"
    "-DEMBREE_RAY_MASK=ON"
  ];

  nativeBuildInputs = [ ispc pkgconfig cmake ];
  buildInputs = [ tbb glfw openimageio libjpeg libpng libX11 libpthreadstubs ];

  meta = with stdenv.lib; {
    description = "High performance ray tracing kernels from Intel";
    homepage = "https://embree.github.io/";
    maintainers = with maintainers; [ hodapp gebner ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
