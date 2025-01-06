{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "pp_loc";
  version = "2.1.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/Armael/pp_loc/releases/download/v${version}/pp_loc-${version}.tbz";
    hash = "sha256-L3NlBdQx6BpP6FGtMQ/ynsTNIMj9N+8FDZ5vEFC6p8s=";
  };

  doCheck = true;

  meta = {
    description = "Quote and highlight input fragments at a given source location";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://armael.github.io/pp_loc/pp_loc/";
  };
}
