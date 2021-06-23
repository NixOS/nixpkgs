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

  # Make this a fixed-output derivation
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  ouputHash = "Xvr2yoIcErt5tCvwonSDN696juc9S9/F/RkAQgrIXOM=";

  meta = {
    description = "A port of the materia theme for Plasma";
    homepage = "https://git.io/materia-kde";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.diffumist ];
    platforms = lib.platforms.all;
  };
}
