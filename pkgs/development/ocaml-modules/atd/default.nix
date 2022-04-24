{ lib, menhir, easy-format, fetchurl, buildDunePackage, which, re, nixosTests }:

buildDunePackage rec {
  pname = "atd";
  version = "2.2.1";

  useDune2 = true;

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/2.2.1/atd-2.2.1.tbz";
    sha256 = "17jm79np69ixp53a4njxnlb1pg8sd1g47nm3nyki9clkc8d4qsyv";
  };

  nativeBuildInputs = [ which menhir ];
  propagatedBuildInputs = [ easy-format re ];

  strictDeps = true;

  doCheck = true;

  passthru.tests = {
    smoke-test = nixosTests.atd;
  };

  meta = with lib; {
    homepage = "https://github.com/mjambon/atd";
    description = "Syntax for cross-language type definitions";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aij jwilberding ];
  };
}
