{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "minisat";
  version = "0.6";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-minisat";
    rev = "v${version}";
    hash = "sha256-dH0Ndlyo/DTZ6Ao1S478aBuxoZFSkRBi5HblkTWCPas=";
  };

  meta = with lib; {
    homepage = "https://c-cube.github.io/ocaml-minisat/";
    description = "Simple bindings to Minisat-C";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mgttlinger ];
  };
}
