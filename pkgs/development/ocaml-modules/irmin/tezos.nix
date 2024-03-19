{ lib, buildDunePackage
, irmin, irmin-pack, ppx_irmin, digestif, cmdliner, fmt, yojson, tezos-base58
, alcotest, hex, irmin-test, fpath
}:

buildDunePackage rec {
  pname = "irmin-tezos";

  inherit (irmin) version src strictDeps;
  duneVersion = "3";

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

  checkInputs = [ alcotest hex irmin-test fpath ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Irmin implementation of the Tezos context hash specification";
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
