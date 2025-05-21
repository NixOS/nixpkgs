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

  meta = with lib; {
    description = "Syntax for cross-language type definitions";
    homepage = "https://github.com/mjambon/atd";
    license = licenses.mit;
    maintainers = with maintainers; [ aij ];
    mainProgram = "atdcat";
  };
}
