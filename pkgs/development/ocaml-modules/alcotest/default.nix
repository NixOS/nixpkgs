{ lib, buildDunePackage, fetchurl
, astring, cmdliner, fmt, uuidm, re, stdlib-shims, uutf
}:

buildDunePackage rec {
  pname = "alcotest";
  version = "1.2.3";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${version}/alcotest-mirage-${version}.tbz";
    sha256 = "1bmjcivbmd4vib15v4chycgd1gl8js9dk94vzxkdg06zxqd4hp08";
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
