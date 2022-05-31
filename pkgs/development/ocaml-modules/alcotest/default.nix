{ lib, buildDunePackage, fetchurl, ocaml
, astring, cmdliner_1_0, cmdliner_1_1, fmt, uuidm, re, stdlib-shims, uutf, ocaml-syntax-shims
}:

let
  cmdliner = if lib.versionAtLeast ocaml.version "4.08" then  cmdliner_1_1 else cmdliner_1_0;
in

buildDunePackage rec {
  pname = "alcotest";
  version = "1.5.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${version}/alcotest-js-${version}.tbz";
    sha256 = "sha256-VCgZB+AteJld8kbcLhDtGCgoKUrSBZNHoeOhM1SEj2w=";
  };

  nativeBuildInputs = [ ocaml-syntax-shims ];

  buildInputs = [ cmdliner ];

  propagatedBuildInputs = [ astring fmt uuidm re stdlib-shims uutf ];

  doCheck = !lib.versionAtLeast ocaml.version "4.08"; # Broken with cmdliner 1.1

  meta = with lib; {
    homepage = "https://github.com/mirage/alcotest";
    description = "A lightweight and colourful test framework";
    license = licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
