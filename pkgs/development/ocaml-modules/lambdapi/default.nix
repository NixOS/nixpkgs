{ lib
, fetchFromGitHub
, buildDunePackage
, alcotest
, dedukti
, bindlib
, camlp-streams
, cmdliner_1_1
, menhir
, pratter
, sedlex
, stdlib-shims
, timed
, why3
, yojson
}:

buildDunePackage rec {
  pname = "lambdapi";
  version = "2.2.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "Deducteam";
    repo = pname;
    rev = version;
    hash = "sha256-p2ZjSfiZwkf8X4fSNJx7bAVpTFl4UBHIEANIWF7NGCs=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    bindlib camlp-streams cmdliner_1_1 pratter sedlex stdlib-shims timed why3 yojson
  ];

  checkInputs = [ alcotest dedukti ];
  doCheck = false;  # "Error: Unbound module Cmd"

  meta = with lib; {
    homepage = "https://github.com/Deducteam/lambdapi";
    description = "Proof assistant based on the λΠ-calculus modulo rewriting";
    license = licenses.cecill21;
    changelog = "https://github.com/Deducteam/lambdapi/raw/${version}/CHANGES.md";
    maintainers = with maintainers; [ bcdarwin ];
  };
}
