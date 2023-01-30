{ lib, buildDunePackage
, macaddr, ppx_sexp_conv, macaddr-cstruct, ounit
}:

buildDunePackage {
  pname = "macaddr-sexp";

  inherit (macaddr) version src;

  propagatedBuildInputs = [ ppx_sexp_conv ];

  nativeCheckInputs = [ macaddr-cstruct ounit ];
  doCheck = true;

  meta = macaddr.meta // {
    description = "A library for manipulation of MAC address representations using sexp";
  };
}
