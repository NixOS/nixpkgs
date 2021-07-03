{ lib, buildDunePackage, fetchurl
, astring, cmdliner, fmt, uuidm, re, stdlib-shims, uutf
}:

buildDunePackage rec {
  pname = "alcotest";
  version = "1.3.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${version}/alcotest-mirage-${version}.tbz";
    sha256 = "sha256-efnevbyolTdNb91zr4pHDcvgaLQQSD01wEu2zMM+iaw=";
  };

  propagatedBuildInputs = [ astring cmdliner fmt uuidm re stdlib-shims uutf ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/alcotest";
    description = "A lightweight and colourful test framework";
    license = licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
