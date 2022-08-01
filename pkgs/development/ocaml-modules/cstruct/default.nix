{ lib, fetchurl, buildDunePackage, fmt, crowbar, alcotest, ocaml }:

buildDunePackage rec {
  pname = "cstruct";
  version = "6.1.0";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-${version}.tbz";
    sha256 = "12qxkyb5q1v2g5b8bcsnvvg7p5gyscpfcqlxbngcjj3hddyjs3ag";
  };

  propagatedBuildInputs = [ fmt crowbar ];

  # alcotest isn't available for OCaml < 4.05 due to fmt
  doCheck = lib.versionAtLeast ocaml.version "4.05";
  checkInputs = [ alcotest ];

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
