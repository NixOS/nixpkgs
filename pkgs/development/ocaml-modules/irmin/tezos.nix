{ buildDunePackage
, irmin, irmin-pack, ppx_irmin, tezos-base58
, digestif, cmdliner_1_1, fmt, yojson
, alcotest, hex, fpath, irmin-test
}:

buildDunePackage {

  pname = "irmin-tezos";

  inherit (irmin) version src;

  useDune2 = true;

  propagatedBuildInputs = [
    irmin irmin-pack ppx_irmin tezos-base58 digestif cmdliner_1_1 fmt yojson
  ];

  doCheck = true;
  checkInputs = [
    alcotest hex fpath irmin-test
  ];

  meta = irmin.meta // {
    description = "Irmin implementation of the Tezos context hash specification";
  };

}
