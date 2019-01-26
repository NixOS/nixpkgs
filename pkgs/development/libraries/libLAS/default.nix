{ stdenv, fetchurl, boost, cmake, gdal, libgeotiff, libtiff, LASzip, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  name = "libLAS-1.8.1";

  src = fetchurl {

    url = "https://download.osgeo.org/liblas/${name}.tar.bz2";
    sha256 = "0xjfxb3ydvr2258ji3spzyf81g9caap19ql2pk91wiivqsc4mnws";
  };

  buildInputs = [ boost cmake gdal libgeotiff libtiff LASzip ]
                ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  cmakeFlags = [
    "-DGDAL_CONFIG=${gdal}/bin/gdal-config"
    "-DWITH_LASZIP=ON"
    "-DLASZIP_INCLUDE_DIR=${LASzip}/include"
  ];

  postFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change "@rpath/liblas.3.dylib" "$out/lib/liblas.3.dylib" $out/lib/liblas_c.dylib
  '';

  meta = {
    description = "LAS 1.0/1.1/1.2 ASPRS LiDAR data translation toolset";
    homepage = https://liblas.org;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.michelk ];
  };
}
