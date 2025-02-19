{
  buildDunePackage,
  mirage-crypto-rng,
  duration,
  mirage-runtime,
  mirage-time,
  mirage-clock,
  mirage-unix,
  mirage-time-unix,
  mirage-clock-unix,
  logs,
  lwt,
  ohex,
}:

buildDunePackage rec {
  pname = "mirage-crypto-rng-mirage";

  inherit (mirage-crypto-rng) version src;

  doCheck = true;
  checkInputs = [
    mirage-unix
    mirage-clock-unix
    mirage-time-unix
    ohex
  ];

  propagatedBuildInputs = [
    duration
    mirage-crypto-rng
    mirage-runtime
    mirage-time
    mirage-clock
    logs
    lwt
  ];

  meta = mirage-crypto-rng.meta // {
    description = "Entropy collection for a cryptographically secure PRNG";
  };
}
