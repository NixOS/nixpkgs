{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "3.1.0";

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/archive/v${version}.tar.gz";
    sha256 = "1hi3v5dzg6h4qb268ch3h6v61gsc8bv21ajhb35z37v5nsdmyzbh";
  };

  propagatedBuildInputs = [ ppx_sexp_conv ];

  doCheck = false; # ipaddr and macaddr tests are together, which requires mutual dependency

  meta = with lib; {
    homepage = https://github.com/mirage/ocaml-ipaddr;
    description = "A library for manipulation of MAC address representations";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
