{ lib, fetchFromGitHub, buildDunePackage
, ppx_sexp_conv, ounit
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "5.2.0";

  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-ipaddr";
    rev = "v${version}";
    sha256 = "QE2OxeFS7Vo4fmosFjKJG/nqEvVxb80y86c+Dg4Kpa8=";
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
