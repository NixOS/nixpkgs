{ stdenv, fetchurl, libtiff }:

stdenv.mkDerivation {
  name = "libgeotiff-1.2.4";

  src = fetchurl {
    url = ftp://ftp.remotesensing.org/pub/geotiff/libgeotiff/libgeotiff-1.2.5.tar.gz;
    sha256 = "0z2yx77pm0zs81hc0b4lwzdd5s0rxcbylnscgq80b649src1fyzj";
  };

  buildInputs = [ libtiff ];

  meta = {
    description = "Library implementing attempt to create a tiff based interchange format for georeferenced raster imagery";
    homepage = http://www.remotesensing.org/geotiff/geotiff.html;
    license = "X11";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
