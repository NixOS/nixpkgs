{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "materia-kde-theme";
  version = "20210814";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "materia-kde";
    rev = version;
    sha256 = "KfC1nB5WUcYixqSy5XCP+6Uqhs07Y3p2F1H+5HB8wAg=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A port of the materia theme for Plasma";
    homepage = "https://github.com/PapirusDevelopmentTeam/materia-kde";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.diffumist ];
    platforms = platforms.all;
  };
}
