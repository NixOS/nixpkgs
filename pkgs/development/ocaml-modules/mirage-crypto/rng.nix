{ buildDunePackage, mirage-crypto, ounit, randomconv, dune-configurator
, cstruct, duration, logs, mtime, ocaml_lwt, mirage-runtime, mirage-time
, mirage-clock, mirage-time-unix, mirage-clock-unix, mirage-unix }:

buildDunePackage {
  pname = "mirage-crypto-rng";

  inherit (mirage-crypto) version src useDune2 minimumOCamlVersion;

  doCheck = true;
  checkInputs = [ ounit randomconv ];

  nativeBuildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ cstruct mirage-crypto duration logs mtime ocaml_lwt
                            mirage-runtime mirage-time mirage-clock mirage-time-unix
                            mirage-clock-unix mirage-unix ];

  meta = mirage-crypto.meta // {
    description = "A cryptographically secure PRNG";
  };
}
