{
  lib,
  buildDunePackage,
  irmin,
  irmin-pack,
  ppx_irmin,
  digestif,
  cmdliner,
  fmt,
  yojson,
  tezos-base58,
  alcotest,
  hex,
  irmin-test,
  fpath,
}:

buildDunePackage {
  pname = "irmin-tezos";

  inherit (irmin) version src;

  propagatedBuildInputs = [
    irmin
    irmin-pack
    ppx_irmin
    digestif
    fmt
    tezos-base58
  ];

  buildInputs = [
    cmdliner
    yojson
  ];

  checkInputs = [
    alcotest
    hex
    irmin-test
    fpath
  ];

  doCheck = lib.versionOlder alcotest.version "1.10";

  meta = irmin.meta // {
    description = "Irmin implementation of the Tezos context hash specification";
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
