{
  buildDunePackage,
  mirage-crypto-rng,
  duration,
  logs,
  mtime,
  lwt,
}:

buildDunePackage {
  pname = "mirage-crypto-rng-lwt";

  inherit (mirage-crypto-rng) version src;

  doCheck = true;

  propagatedBuildInputs = [
    mirage-crypto-rng
    duration
    logs
    mtime
    lwt
  ];

  meta = mirage-crypto-rng.meta;
}
