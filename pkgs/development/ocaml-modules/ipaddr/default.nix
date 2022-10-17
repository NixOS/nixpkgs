{ lib, buildDunePackage
, macaddr, domain-name, stdlib-shims
, ounit, ppx_sexp_conv
}:

buildDunePackage rec {
  pname = "ipaddr";

  inherit (macaddr) version src;

  propagatedBuildInputs = [ macaddr domain-name stdlib-shims ];

  checkInputs = [ ppx_sexp_conv ounit ];
  doCheck = true;

  meta = macaddr.meta // {
    description = "A library for manipulation of IP (and MAC) address representations ";
    maintainers = with lib.maintainers; [ alexfmpe ericbmerritt ];
  };
}
