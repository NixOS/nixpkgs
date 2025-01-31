{
  lib,
  atdgen-codec-runtime,
  cmdliner,
  menhir,
  easy-format,
  buildDunePackage,
  re,
  yojson,
  nixosTests,
  version ? "2.16.0",
}:
let
  atdgen-codec-runtime-override = atdgen-codec-runtime.override {
    inherit version;
  };
in
buildDunePackage {
  pname = "atd";
  inherit (atdgen-codec-runtime-override) version src;

  minimalOCamlVersion = "4.08";

  nativeBuildInputs = [ menhir ];
  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [
    easy-format
    re
    yojson
  ];

  passthru.tests = {
    smoke-test = nixosTests.atd;
  };

  meta = {
    description = "Syntax for cross-language type definitions";
    homepage = "https://github.com/mjambon/atd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aij ];
    mainProgram = "atdcat";
  };
}
