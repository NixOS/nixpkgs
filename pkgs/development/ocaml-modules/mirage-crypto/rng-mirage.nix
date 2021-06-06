{ buildDunePackage, mirage-crypto-rng, duration, cstruct, mirage-runtime
, mirage-time, mirage-clock, mirage-unix, mirage-time-unix, mirage-clock-unix
, logs, lwt
}:

buildDunePackage {
  pname = "mirage-crypto-rng-mirage";

  inherit (mirage-crypto-rng) version src useDune2 minimumOCamlVersion;

  doCheck = true;
  checkInputs = [ mirage-unix mirage-clock-unix mirage-time-unix ];

  propagatedBuildInputs = [ duration cstruct mirage-crypto-rng mirage-runtime
                            mirage-time mirage-clock logs lwt ];

  meta = mirage-crypto-rng.meta // {
    description = "Entropy collection for a cryptographically secure PRNG";
  };
}
