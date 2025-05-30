{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
  dedukti,
  bindlib,
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
  version = "2.6.0";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/Deducteam/lambdapi/releases/download/${version}/lambdapi-${version}.tbz";
    hash = "sha256-0B5fE9suq6bk/jMGZxSeAFnUiGxlH/nWtnLbLfyXZe0=";
  };

  nativeBuildInputs = [
    dream
    menhir
  ];
  buildInputs = [ lwt_ppx ];
  propagatedBuildInputs = [
    bindlib
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
