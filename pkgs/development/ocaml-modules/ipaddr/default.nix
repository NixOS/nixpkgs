{ lib, buildDunePackage
, macaddr, domain-name, stdlib-shims
, ounit2, ppx_sexp_conv
}:

buildDunePackage rec {
  pname = "ipaddr";

  inherit (macaddr) version src;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [ macaddr domain-name stdlib-shims ];

  checkInputs = [ ppx_sexp_conv ounit2 ];
  doCheck = true;

  meta = macaddr.meta // {
    description = "Library for manipulation of IP (and MAC) address representations";
    maintainers = with lib.maintainers; [ alexfmpe ericbmerritt ];
  };
}
