{ lib
, buildDunePackage
, fetchurl

, ppx_fields_conv
, ppx_sexp_conv

, cohttp-lwt
, ezjsonm
, hmap
, sexplib
, fieldslib
}:

buildDunePackage rec {
  pname = "opium_kernel";
  version = "0.18.0";

  useDune2 = true;

  minimumOCamlVersion = "4.04.1";

  src = fetchurl {
    url = "https://github.com/rgrinberg/opium/releases/download/${version}/opium-${version}.tbz";
    sha256 = "0a2y9gw55psqhqli3a5ps9mfdab8r46fnbj882r2sp366sfcy37q";
  };

  doCheck = true;

  buildInputs = [
    ppx_sexp_conv ppx_fields_conv
  ];

  propagatedBuildInputs = [
    hmap cohttp-lwt ezjsonm sexplib fieldslib
  ];

  meta = {
    description = "Sinatra like web toolkit for OCaml based on cohttp & lwt";
    homepage = "https://github.com/rgrinberg/opium";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pmahoney ];
  };
}
