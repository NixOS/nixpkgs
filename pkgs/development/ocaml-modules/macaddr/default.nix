{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, ounit
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "5.0.0";

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/archive/v${version}.tar.gz";
    sha256 = "1j2m2v64g3d81sixxq3g57j1iyk6042ivsszml18akrqvwfpxy66";
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
