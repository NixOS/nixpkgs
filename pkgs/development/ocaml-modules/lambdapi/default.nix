{ lib
, fetchurl
, buildDunePackage
, alcotest
, dedukti
, bindlib
, camlp-streams
, cmdliner
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
  version = "2.3.1";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/Deducteam/lambdapi/releases/download/${version}/lambdapi-${version}.tbz";
    hash = "sha256-7ww2TjVcbEQyfmLnnEhLGAjW4US9a4mdOfDJw6NR1fI=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [
    bindlib camlp-streams cmdliner pratter sedlex stdlib-shims timed why3 yojson
  ];

  checkInputs = [ alcotest dedukti ];
  doCheck = false; # anomaly: Sys_error("/homeless-shelter/.why3.conf: No such file or directory")

  meta = with lib; {
    homepage = "https://github.com/Deducteam/lambdapi";
    description = "Proof assistant based on the λΠ-calculus modulo rewriting";
    license = licenses.cecill21;
    changelog = "https://github.com/Deducteam/lambdapi/raw/${version}/CHANGES.md";
    maintainers = with maintainers; [ bcdarwin ];
  };
}
