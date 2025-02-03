{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ounit,
}:

buildDunePackage {
  pname = "mlbdd";
  version = "0.7.2";

  minimalOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "arlencox";
    repo = "mlbdd";
    rev = "v0.7.2";
    hash = "sha256-GRkaUL8LQDdQx9mPvlJIXatgRfen/zKt+nGLiH7Mfvs=";
  };

  checkInputs = [ ounit ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/arlencox/mlbdd";
    description = "A not-quite-so-simple Binary Decision Diagrams implementation for OCaml";
    maintainers = with lib.maintainers; [ katrinafyi ];
  };
}
