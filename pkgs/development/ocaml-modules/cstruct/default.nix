{ lib, fetchurl, buildDunePackage, fmt, alcotest, crowbar, ocaml }:

buildDunePackage rec {
  pname = "cstruct";
  version = "6.1.0";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-${version}.tbz";
    sha256 = "sha256-Tw0tfWtwSMmeXZ1i5i7T/pV73t5Ws4VWeWIHXJafHYs=";
  };

  propagatedBuildInputs = [ fmt ];

  doCheck = true;
  checkInputs = [ alcotest crowbar ];

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
