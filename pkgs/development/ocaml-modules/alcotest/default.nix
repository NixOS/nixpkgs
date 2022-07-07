{ lib, buildDunePackage, fetchurl
, astring, cmdliner, fmt, uuidm, re, stdlib-shims, uutf, ocaml-syntax-shims
}:

buildDunePackage rec {
  pname = "alcotest";
  version = "1.5.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${version}/alcotest-js-${version}.tbz";
    sha256 = "sha256-VCgZB+AteJld8kbcLhDtGCgoKUrSBZNHoeOhM1SEj2w=";
  };

  nativeBuildInputs = [ ocaml-syntax-shims ];

  propagatedBuildInputs = [ astring cmdliner fmt uuidm re stdlib-shims uutf ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/alcotest";
    description = "A lightweight and colourful test framework";
    license = licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
