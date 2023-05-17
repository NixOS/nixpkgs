{ lib, stdenv, fetchurl, hunspell, ncurses, pkg-config, perl }:

stdenv.mkDerivation rec {
  pname = "mythes";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/hunspell/mythes-${version}.tar.gz";
    sha256 = "0prh19wy1c74kmzkkavm9qslk99gz8h8wmjvwzjc6lf8v2az708y";
  };

  buildInputs = [ hunspell ];
  nativeBuildInputs = [ ncurses pkg-config perl ];

  meta = {
    homepage = "https://hunspell.sourceforge.net/";
    description = "Thesaurus library from Hunspell project";
    license = lib.licenses.bsd3;
    inherit (hunspell.meta) platforms;
  };
}
