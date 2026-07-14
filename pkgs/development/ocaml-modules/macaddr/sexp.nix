{
  buildDunePackage,
  macaddr,
  ppx_sexp_conv,
  macaddr-cstruct,
  ounit2,
}:

buildDunePackage {
  pname = "macaddr-sexp";

  inherit (macaddr) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ ppx_sexp_conv ];

  checkInputs = [
    macaddr-cstruct
    ounit2
  ];
  doCheck = true;

  meta = macaddr.meta // {
    description = "Library for manipulation of MAC address representations using sexp";
  };
}
