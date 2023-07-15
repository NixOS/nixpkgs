{ buildDunePackage, mirage-crypto, mirage-crypto-rng, dune-configurator
, duration, logs, mtime, lwt }:

buildDunePackage rec {
  pname = "mirage-crypto-rng-lwt";

  inherit (mirage-crypto) version src;

  duneVersion = "3";

  doCheck = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ mirage-crypto mirage-crypto-rng duration logs mtime lwt ];

  meta = mirage-crypto-rng.meta;
}
