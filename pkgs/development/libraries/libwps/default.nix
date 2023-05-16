{ lib, stdenv, fetchurl, boost, pkg-config, librevenge, zlib }:

stdenv.mkDerivation rec {
  pname = "libwps";
<<<<<<< HEAD
  version = "0.4.14";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/${pname}-${version}.tar.bz2";
    sha256 = "sha256-xVEdlAngO446F50EZcHMKW7aBvyDcTVu9Egs2oaIadE=";
=======
  version = "0.4.13";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/${pname}-${version}.tar.bz2";
    sha256 = "sha256-eVwva90EwLZgrMpRTcc2cAc9PG5wbXbV2GtK2BMpLrk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ boost librevenge zlib ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-fallthrough";

  meta = with lib; {
    homepage = "https://libwps.sourceforge.net/";
    description = "Microsoft Works document format import filter library";
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
