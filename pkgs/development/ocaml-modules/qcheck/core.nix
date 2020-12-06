{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "qcheck-core";
  version = "0.16";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    rev = version;
    sha256 = "1s5dpqj8zvd3wr2w3fp4wb6yc57snjpxzzfv9fb6l9qgigswwjdr";
  };

  meta = {
    description = "Core qcheck library";
    homepage = "https://c-cube.github.io/qcheck/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
