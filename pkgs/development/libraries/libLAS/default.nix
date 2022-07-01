{ lib, stdenv, fetchurl, boost, cmake, gdal, libgeotiff, libtiff, LASzip2, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "libLAS";
  version = "1.8.1";

  src = fetchurl {
    url = "https://download.osgeo.org/liblas/libLAS-${version}.tar.bz2";
    sha256 = "0xjfxb3ydvr2258ji3spzyf81g9caap19ql2pk91wiivqsc4mnws";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = [ boost gdal libgeotiff libtiff LASzip2 ];

  cmakeFlags = [
    "-DGDAL_CONFIG=${gdal}/bin/gdal-config"
    "-DWITH_LASZIP=ON"
    # libLAS is currently not compatible with LASzip 3,
    # see https://github.com/libLAS/libLAS/issues/144.
    "-DLASZIP_INCLUDE_DIR=${LASzip2}/include"
    "-DCMAKE_EXE_LINKER_FLAGS=-pthread"
  ];

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change "@rpath/liblas.3.dylib" "$out/lib/liblas.3.dylib" $out/lib/liblas_c.dylib
  '';

  meta = {
    description = "LAS 1.0/1.1/1.2 ASPRS LiDAR data translation toolset";
    homepage = "https://liblas.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.michelk ];
  };
}
