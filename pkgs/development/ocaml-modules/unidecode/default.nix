{
  buildDunePackage,
  fetchFromGitHub,
  lib,
}:

buildDunePackage {
  pname = "unidecode";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "geneweb";
    repo = "unidecode";
    rev = "v0.5.0";
    hash = "sha256-lz58gNITK9IG44pvoIVaMBt21mjDXA2avaL8Wmp/z8s=";
  };

  meta = with lib; {
    description = "Unicode transliteration library";
    homepage = "https://github.com/geneweb/unidecode";
    license = licenses.lgpl21Only;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ lib.maintainers.darkone ];
  };
}
