{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, ounit
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "5.0.1";

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/archive/v${version}.tar.gz";
    sha256 = "0ffqkhmnj8l085xgl7jxhs3ld9zsd9iavdg06nnhr1i9g1aayk1b";
  };

  checkInputs = [ ppx_sexp_conv ounit ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-ipaddr";
    description = "A library for manipulation of MAC address representations";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
