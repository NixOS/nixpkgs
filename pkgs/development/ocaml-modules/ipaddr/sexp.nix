{ lib, buildDunePackage
, ipaddr, ipaddr-cstruct, ounit2, ppx_sexp_conv
}:

buildDunePackage rec {
  pname = "ipaddr-sexp";

  inherit (ipaddr) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ ipaddr ];

  checkInputs = [ ipaddr-cstruct ounit2 ppx_sexp_conv ];
  doCheck = true;

  meta = ipaddr.meta // {
    description = "A library for manipulation of IP address representations usnig sexp";
  };
}
