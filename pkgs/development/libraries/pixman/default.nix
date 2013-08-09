{ fetchurl, stdenv, pkgconfig, perl, withPNG ? true, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-0.30.2";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "1sgnpx34pj3245a9v8056jddc4cg4xxkqdjvvw6k2hnprhh8k65x";
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
