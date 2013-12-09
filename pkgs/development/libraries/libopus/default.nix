{ stdenv, fetchurl, fixedPoint ? false }:

let
  version = "1.1";
in
stdenv.mkDerivation rec {
  name = "libopus-${version}";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/opus-${version}.tar.gz";
    sha256 = "158xprn2086arvdib3vbbygz7z6jqkw2nci7nlywzzwallap0wmr";
  };

  configureFlags = stdenv.lib.optionalString fixedPoint "--enable-fixed-point";

  doCheck = true;

  meta = {
    description = "Open, royalty-free, highly versatile audio codec";
    license = "BSD";
    homepage = http://www.opus-codec.org/;
  };
}
