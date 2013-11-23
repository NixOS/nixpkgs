{ fetchurl, stdenv, pkgconfig, perl, withPNG ? true, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-0.32.4";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "113ycngcssbrps217dyajq96hm9xghsfch82h14yffla1r1fviw0";
  };

  nativeBuildInputs = [ pkgconfig perl ];

  buildInputs = stdenv.lib.optional withPNG [ libpng ]; # NOT in closure anyway

  postInstall = glib.flattenInclude;

  meta = {
    homepage = http://pixman.org;
    description = "A low-level library for pixel manipulation";
    license = "MIT";
  };
}
