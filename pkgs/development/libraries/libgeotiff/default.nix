{ stdenv, fetchurl, libtiff, libjpeg, proj, zlib}:

stdenv.mkDerivation rec {
  version = "1.4.2";
  name = "libgeotiff-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/geotiff/libgeotiff/${name}.tar.gz";
    sha256 = "0vjy3bwfhljjx66p9w999i4mdhsf7vjshx29yc3pn5livf5091xd";
  };

  configureFlags = [
    "--with-jpeg=${libjpeg.dev}"
    "--with-zlib=${zlib.dev}"
  ];
  buildInputs = [ libtiff proj ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Library implementing attempt to create a tiff based interchange format for georeferenced raster imagery";
    homepage = https://www.remotesensing.org/geotiff/geotiff.html;
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
