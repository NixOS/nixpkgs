{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "cm-unicode";
  version = "0.7.0";

  src = fetchzip {
    url = "mirror://sourceforge/cm-unicode/cm-unicode/${version}/${pname}-${version}-otf.tar.xz";
    sha256 = "1l9ql47xl6nbfxrmvhs0pjbscs4nbqxi98v1a7c7llznywffkm2s";
  };

  meta = with lib; {
    homepage = "http://canopus.iacp.dvo.ru/~panov/cm-unicode/";
    description = "Computer Modern Unicode fonts";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
