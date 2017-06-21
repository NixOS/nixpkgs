{ stdenv, fetchurl, fetchpatch
, fixedPoint ? false, withCustomModes ? true }:

let
  version = "1.2";
in
stdenv.mkDerivation rec {
  name = "libopus-${version}";

  src = fetchurl {
    url = "https://archive.mozilla.org/pub/opus/opus-${version}.tar.gz";
    sha256 = "1ad9q2g9vivx409jdsslv1hrh5r616qz2pjm96y8ymsigfl4bnvp";
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
