{
  buildDunePackage,
  ohex,
  ounit2,
  randomconv,
  mirage-crypto,
  mirage-crypto-rng,
  sexplib0,
  zarith,
  gmp,
}:

buildDunePackage rec {
  pname = "mirage-crypto-pk";

  inherit (mirage-crypto) version src;

  buildInputs = [ gmp ];
  propagatedBuildInputs = [
    mirage-crypto
    mirage-crypto-rng
    zarith
    sexplib0
  ];

  doCheck = true;
  checkInputs = [
    ohex
    ounit2
    randomconv
  ];

  meta = mirage-crypto.meta // {
    description = "Simple public-key cryptography for the modern age";
  };
}
