{ lib, buildDunePackage, alcotest
, functoria, mirage-runtime, bos
, ipaddr, astring, logs, stdlib-shims
}:

buildDunePackage rec {
  pname = "mirage";
  inherit (mirage-runtime) version src;

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [
    ipaddr
    functoria
    mirage-runtime
    bos
    astring
    logs
    stdlib-shims
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = mirage-runtime.meta // {
    description = "The MirageOS library operating system";
  };
}
