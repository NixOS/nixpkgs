{ stdenv, fetchurl, libtiff, libjpeg, proj, zlib}:

stdenv.mkDerivation rec {
  version = "1.4.3";
  name = "libgeotiff-${version}";

  src = fetchurl {
    url = "https://download.osgeo.org/geotiff/libgeotiff/${name}.tar.gz";
    sha256 = "0rbjqixi4c8yz19larlzq6jda0px2gpmpp9c52cyhplbjsdhsldq";
  };

  configureFlags = [
    "--with-jpeg=${libjpeg.dev}"
    "--with-zlib=${zlib.dev}"
  ];
  buildInputs = [ libtiff proj ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Library implementing attempt to create a tiff based interchange format for georeferenced raster imagery";
    homepage = https://github.com/OSGeo/libgeotiff;
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
