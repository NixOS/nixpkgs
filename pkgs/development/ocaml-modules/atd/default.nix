{ lib, atdgen-codec-runtime, menhir, easy-format, buildDunePackage, re, yojson, nixosTests }:

buildDunePackage rec {
  pname = "atd";
  inherit (atdgen-codec-runtime) version src;

  minimalOCamlVersion = "4.08";

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [ easy-format re yojson ];

  strictDeps = true;

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
