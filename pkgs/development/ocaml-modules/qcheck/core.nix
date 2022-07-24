{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "qcheck-core";
  version = "0.19.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    rev = "v${version}";
    sha256 = "sha256-AZ1Ww6CWt3X1bXXcofMe14rTlMTC9hmohcKdZLUKEvE=";
  };

  meta = {
    description = "Core qcheck library";
    homepage = "https://c-cube.github.io/qcheck/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
