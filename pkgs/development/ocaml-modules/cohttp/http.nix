{
  buildDunePackage,
  cohttp,
  base_quickcheck,
  alcotest,
  ppx_expect,
  crowbar,
}:

buildDunePackage {
  pname = "http";
  inherit (cohttp)
    version
    src
    ;

  duneVersion = "3";

  buildInputs = [ ];

  doCheck = true;

  propagatedBuildInputs = [ ];

  checkInputs = [
    base_quickcheck
    alcotest
    ppx_expect
    crowbar
  ];

  meta = cohttp.meta // {
    description = "Type definitions of HTTP essentials";
  };
}
