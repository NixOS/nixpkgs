{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "minisat";
  version = "0.3";

  useDune2 = true;

  minimumOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner  = "c-cube";
    repo   = "ocaml-minisat";
    rev    = "v${version}";
    sha256 = "01wggbziqz5x6d7mwdl40sbf6qal7fd853b224zjf9n0kzzsnczh";
  };

  meta = {
    homepage = "https://c-cube.github.io/ocaml-minisat/";
    description = "Simple bindings to Minisat-C";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
}
