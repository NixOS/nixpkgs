{ fetchurl, stdenv, pkgconfig, perl, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-0.32.6";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "0129g4zdrw5hif5783li7rzcr4vpbc2cfia91azxmsk0h0xx3zix";
  };

  nativeBuildInputs = [ pkgconfig perl ];

  buildInputs = [ libpng ]; # NOT in closure anyway

  postInstall = glib.flattenInclude;

  meta = {
    homepage = http://pixman.org;
    description = "A low-level library for pixel manipulation";
    license = stdenv.lib.licenses.mit;
  };
}
