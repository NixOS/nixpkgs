{ buildDunePackage, mirage-crypto, ounit2, randomconv, dune-configurator
, cstruct, duration, logs }:

buildDunePackage rec {
  pname = "mirage-crypto-rng";

  inherit (mirage-crypto) version src;

  doCheck = true;
  checkInputs = [ ounit2 randomconv ];

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ cstruct mirage-crypto duration logs ];

  strictDeps = true;

  meta = mirage-crypto.meta // {
    description = "A cryptographically secure PRNG";
  };
}
