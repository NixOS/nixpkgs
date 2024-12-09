{ lib, buildDunePackage, fetchurl, cstruct, fmt, lwt }:

buildDunePackage rec {
  pname = "mirage-flow";
  version = "4.0.2";

  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-flow/releases/download/v${version}/mirage-flow-${version}.tbz";
    hash = "sha256-SGXj3S4b53O9JENUFuMl3I+QoiZ0QSrYu7zTet7q+1o=";
  };

  propagatedBuildInputs = [ cstruct fmt lwt ];

  meta = {
    description = "Flow implementations and combinators for MirageOS";
    homepage = "https://github.com/mirage/mirage-flow";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}


