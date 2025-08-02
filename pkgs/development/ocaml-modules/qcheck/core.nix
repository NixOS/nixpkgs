{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "qcheck-core";
  version = "0.26";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    tag = "v${version}";
    hash = "sha256-AZb9ae2LbdSh+jqor9dIctWOzpxT9qI5aAa4K2NKSxY=";
  };

  meta = {
    description = "Core qcheck library";
    homepage = "https://c-cube.github.io/qcheck/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
