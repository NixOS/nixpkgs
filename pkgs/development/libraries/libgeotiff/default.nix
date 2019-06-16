{ stdenv, fetchurl, libtiff, libjpeg, proj, zlib}:

stdenv.mkDerivation rec {
  version = "1.5.1";
  name = "libgeotiff-${version}";

  src = fetchurl {
    url = "https://github.com/OSGeo/libgeotiff/releases/download/${version}/${name}.tar.gz";
    sha256 = "0b31mlzcv5b1y7jdvb7p0pa3xradrg3x5g32ym911lbhq4rrgsgr";
  };

  configureFlags = [
    "--with-jpeg=${libjpeg.dev}"
    "--with-zlib=${zlib.dev}"
  ];
  buildInputs = [ libtiff proj ];

  meta = {
    description = "Library implementing attempt to create a tiff based interchange format for georeferenced raster imagery";
    homepage = https://github.com/OSGeo/libgeotiff;
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
