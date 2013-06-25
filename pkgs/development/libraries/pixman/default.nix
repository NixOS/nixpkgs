{ fetchurl, stdenv, pkgconfig, perl, withPNG ? true, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-0.28.2";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "0mcvxd5gx3w1wzgph91l2vaiic91jmx7s01hi2igphyvd80ckyia";
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
