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
}:

buildDunePackage {
  pname = "atd";
  inherit (atdgen-codec-runtime) version src;

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
