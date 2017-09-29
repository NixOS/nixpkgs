{ stdenv, fetchurl, fetchpatch
, fixedPoint ? false, withCustomModes ? true }:

let
  version = "1.2.1";
in
stdenv.mkDerivation rec {
  name = "libopus-${version}";

  src = fetchurl {
    url = "https://archive.mozilla.org/pub/opus/opus-${version}.tar.gz";
    sha256 = "0ch7yzgg4bn1g36bpjsfrgs4n19c84d7wpdida6yzifrrhwx7byg";
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
    maintainers = with maintainers; [ wkennington ];
  };
}
