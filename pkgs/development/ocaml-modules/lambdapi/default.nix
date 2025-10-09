{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
  dedukti,
  camlp-streams,
  cmdliner,
  dream,
  lwt_ppx,
  menhir,
  pratter,
  sedlex,
  stdlib-shims,
  timed,
  why3,
  yojson,
}:

buildDunePackage rec {
  pname = "lambdapi";
  version = "3.0.0";

  minimalOCamlVersion = "4.14";

  src = fetchurl {
    url = "https://github.com/Deducteam/lambdapi/releases/download/${version}/lambdapi-${version}.tbz";
    hash = "sha256-EGau0mGP2OakAMUUfb9V6pd86NP+LlGKxnhcZ3WhuL4=";
  };

  nativeBuildInputs = [
    dream
    menhir
  ];
  buildInputs = [ lwt_ppx ];
  propagatedBuildInputs = [
    camlp-streams
    cmdliner
    dream
    pratter
    sedlex
    stdlib-shims
    timed
    why3
    yojson
  ];

  checkInputs = [
    alcotest
    dedukti
  ];
  doCheck = false; # anomaly: Sys_error("/homeless-shelter/.why3.conf: No such file or directory")

  meta = with lib; {
    homepage = "https://github.com/Deducteam/lambdapi";
    description = "Proof assistant based on the λΠ-calculus modulo rewriting";
    license = licenses.cecill21;
    changelog = "https://github.com/Deducteam/lambdapi/raw/${version}/CHANGES.md";
    maintainers = with maintainers; [ bcdarwin ];
  };
}
