{ lib, fetchurl, buildDunePackage, ocaml
, ppx_sexp_conv, ounit2
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "5.6.0";

  minimalOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/releases/download/v${version}/ipaddr-${version}.tbz";
    hash = "sha256-njBDP9tMpDemqo/7RHuspeunYV+4jnsM2KS0FsMggTM=";
  };

  checkInputs = [ ppx_sexp_conv ounit2 ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-ipaddr";
    description = "Library for manipulation of MAC address representations";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
