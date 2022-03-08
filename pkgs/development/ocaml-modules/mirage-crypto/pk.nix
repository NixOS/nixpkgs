{ buildDunePackage, ounit, randomconv, mirage-crypto, mirage-crypto-rng
, cstruct, sexplib0, zarith, eqaf, gmp }:

buildDunePackage rec {
  pname = "mirage-crypto-pk";

  inherit (mirage-crypto) version src useDune2 minimumOCamlVersion;

  buildInputs = [ gmp ];
  propagatedBuildInputs = [ cstruct mirage-crypto mirage-crypto-rng
                            zarith eqaf sexplib0 ];

  strictDeps = !doCheck;

  doCheck = true;
  checkInputs = [ ounit randomconv ];

  meta = mirage-crypto.meta // {
    description = "Simple public-key cryptography for the modern age";
  };
}
