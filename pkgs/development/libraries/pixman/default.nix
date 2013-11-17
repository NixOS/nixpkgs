{ fetchurl, stdenv, pkgconfig, perl, withPNG ? true, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-0.32.2";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "0kas43iw0wxw22z6gafsx15f8p73x991gw35asnah2myqw43x7pn";
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
