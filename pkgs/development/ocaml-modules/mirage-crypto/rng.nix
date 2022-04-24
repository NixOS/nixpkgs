{ buildDunePackage, mirage-crypto, ounit, randomconv, dune-configurator
, cstruct, duration, logs, mtime, ocaml_lwt }:

buildDunePackage rec {
  pname = "mirage-crypto-rng";

  inherit (mirage-crypto) version src useDune2 minimumOCamlVersion;

  doCheck = true;
  checkInputs = [ ounit randomconv ];

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ cstruct mirage-crypto duration logs mtime ocaml_lwt ];

  strictDeps = !doCheck;

  meta = mirage-crypto.meta // {
    description = "A cryptographically secure PRNG";
  };
}
