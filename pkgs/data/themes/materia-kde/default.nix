{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "materia-kde-theme";
  version = "20210612";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "materia-kde";
    rev = version;
    sha256 = "P76rLj7x4KpYb3hdHBSUM8X/RcxKoJl1THIXHdfPoAY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A port of the materia theme for Plasma";
    homepage = "https://github.com/PapirusDevelopmentTeam/materia-kde";
    license = licenses.gpl3;
    maintainers = [ maintainers.diffumist ];
    platforms = platforms.all;
  };
}
