{ lib, buildDunePackage, fetchurl, cstruct, fmt, ocaml_lwt }:

buildDunePackage rec {
  pname = "mirage-flow";
  version = "3.0.0";

  useDune2 = true;
  minimumOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-flow/releases/download/v${version}/mirage-flow-v${version}.tbz";
    sha256 = "sha256-1wvabIXsJ0e+2IvE2V8mnSgQUDuSkT8IB75SkWlhOPw=";
  };

  propagatedBuildInputs = [ cstruct fmt ocaml_lwt ];

  meta = {
    description = "Flow implementations and combinators for MirageOS";
    homepage = "https://github.com/mirage/mirage-flow";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}


