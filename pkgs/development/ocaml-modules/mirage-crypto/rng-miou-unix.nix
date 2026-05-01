{
  buildDunePackage,
  mirage-crypto-rng,
  miou,
  logs,
  duration,
  mtime,
  digestif,
  ohex,
}:

buildDunePackage {
  pname = "mirage-crypto-rng-miou-unix";

  inherit (mirage-crypto-rng) version src;

  doCheck = true;
  checkInputs = [

  ];

  propagatedBuildInputs = [
    miou
    logs
    mirage-crypto-rng
    duration
    mtime
    digestif
    ohex
  ];

  meta = mirage-crypto-rng.meta // {
    description = "Feed the entropy source in an miou.unix-friendly way";
    longDescription = ''
      Mirage-crypto-rng-miou-unix feeds the entropy source for Mirage_crypto_rng-based
      random number generator implementations, in an miou.unix-friendly way.
    '';
  };
}
