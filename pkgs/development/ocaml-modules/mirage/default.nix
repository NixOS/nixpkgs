{ lib, buildDunePackage, ocaml, alcotest
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

  installPhase = ''
    runHook preInstall
    dune install --prefix=$out --libdir=$dev/lib/ocaml/${ocaml.version}/site-lib/ ${pname}
    runHook postInstall
  '';

  meta = mirage-runtime.meta // {
    description = "The MirageOS library operating system";
  };
}
