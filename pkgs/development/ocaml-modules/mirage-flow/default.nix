{ lib, buildDunePackage, fetchurl, cstruct, fmt, ocaml_lwt }:

buildDunePackage rec {
  pname = "mirage-flow";
  version = "2.0.1";

  minimumOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-flow/releases/download/v${version}/mirage-flow-v${version}.tbz";
    sha256 = "13v05x34six0z6bc2is8qhvbxk4knxh80ardi5x4rl738vlq3mn9";
  };

  propagatedBuildInputs = [ cstruct fmt ocaml_lwt ];

  meta = {
    description = "Flow implementations and combinators for MirageOS";
    homepage = "https://github.com/mirage/mirage-flow";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}


