{
  stdenv,
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage rec {
  duneVersion = "3";
  pname = "tatl";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "theoremprover-museum";
    repo = "TATL";
    tag = "v${version}";
    sha256 = "sha256-leP02141kZSUmCDXOfV0TsEn+OQ6WoyM7+9NutLX1qk=";
  };

  nativeBuildInputs = [ ocamlPackages.menhir ];
  propagatedBuildInputs = [ ocamlPackages.ocamlgraph ];

  meta = {
    description = "Implementation of a tableau-based decision procedure for the full Alternating-time Temporal Logic (ATL*)";
    homepage = "https://atila.ibisc.univ-evry.fr/tableau_ATL_star/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mgttlinger ];
  };
}
