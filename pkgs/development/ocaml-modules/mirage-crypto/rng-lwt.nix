{ buildDunePackage, mirage-crypto, mirage-crypto-rng, dune-configurator
, duration, logs, mtime, ocaml_lwt }:

buildDunePackage rec {
  pname = "mirage-crypto-rng-lwt";

  inherit (mirage-crypto) version src;

  doCheck = true;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ mirage-crypto mirage-crypto-rng duration logs mtime ocaml_lwt ];

  meta = mirage-crypto-rng.meta;
}
