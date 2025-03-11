{
  buildDunePackage,
  ohex,
  ounit2,
  randomconv,
  mirage-crypto,
  mirage-crypto-rng,
  zarith,
  gmp,
}:

buildDunePackage {
  pname = "mirage-crypto-pk";

  inherit (mirage-crypto) version src;

  buildInputs = [ gmp ];
  propagatedBuildInputs = [
    mirage-crypto
    mirage-crypto-rng
    zarith
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
