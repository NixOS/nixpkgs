{ lib
, stdenv
, fetchFromGitHub
, unzip
, cmake
, libtiff
, expat
, zlib
, libpng
, libjpeg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vxl";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "vxl";
    repo = "vxl";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-4kMpIrywEZzt0JH95LHeDLrDneii0R/Uw9GsWkvED+E=";
  };

  nativeBuildInputs = [
    cmake
    unzip
  ];
  buildInputs = [
    libtiff
    expat
    zlib
    libpng
    libjpeg
  ];

  # test failure on aarch64-linux; unknown reason:
  cmakeFlags = lib.optionals stdenv.isAarch64 [ "-DCMAKE_CTEST_ARGUMENTS='-E vgl_test_frustum_3d'" ];

  doCheck = true;

  meta = {
    description = "C++ Libraries for Computer Vision Research and Implementation";
    homepage = "https://vxl.sourceforge.net";
    # license appears contradictory; see https://github.com/vxl/vxl/issues/752
    # (and see https://github.com/InsightSoftwareConsortium/ITK/pull/1920/files for potential patch)
    license = [ lib.licenses.unfree ];
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
})
