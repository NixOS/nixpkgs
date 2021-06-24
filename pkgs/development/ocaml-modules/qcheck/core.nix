{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "qcheck-core";
  version = "0.17";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    rev = version;
    sha256 = "0qfyqhfg98spmfci9z6f527a16gwjnx2lrbbgw67p37ys5acrfar";
  };

  meta = {
    description = "Core qcheck library";
    homepage = "https://c-cube.github.io/qcheck/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
