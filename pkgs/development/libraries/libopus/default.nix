{ stdenv, fetchurl
, fixedPoint ? false, withCustomModes ? true }:

let
  version = "1.3.1";
in
stdenv.mkDerivation rec {
  name = "libopus-${version}";

  src = fetchurl {
    url = "https://archive.mozilla.org/pub/opus/opus-${version}.tar.gz";
    sha256 = "17gz8kxs4i7icsc1gj713gadiapyklynlwqlf0ai98dj4lg8xdb5";
  };

  outputs = [ "out" "dev" ];

  configureFlags = stdenv.lib.optional fixedPoint "--enable-fixed-point"
                ++ stdenv.lib.optional withCustomModes "--enable-custom-modes";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Open, royalty-free, highly versatile audio codec";
    license = stdenv.lib.licenses.bsd3;
    homepage = http://www.opus-codec.org/;
    platforms = platforms.unix;
  };
}
