{ lib, atdgen-codec-runtime, menhir, easy-format, buildDunePackage, which, re, nixosTests }:

buildDunePackage rec {
  pname = "atd";
  inherit (atdgen-codec-runtime) version src;

  minimalOCamlVersion = "4.08";

  nativeBuildInputs = [ which menhir ];
  buildInputs = [ re ];
  propagatedBuildInputs = [ easy-format ];

  strictDeps = true;

  passthru.tests = {
    smoke-test = nixosTests.atd;
  };

  meta = with lib; {
    homepage = "https://github.com/mjambon/atd";
    description = "Syntax for cross-language type definitions";
    license = licenses.mit;
    maintainers = with maintainers; [ aij jwilberding ];
  };
}
