{ buildDunePackage, ounit2, randomconv, mirage-crypto, mirage-crypto-rng
, cstruct, sexplib0, zarith, eqaf-cstruct, gmp }:

buildDunePackage rec {
  pname = "mirage-crypto-pk";

  inherit (mirage-crypto) version src;

  postPatch = ''
    substituteInPlace pk/dune --replace-warn eqaf.cstruct eqaf-cstruct
  '';

  buildInputs = [ gmp ];
  propagatedBuildInputs = [ cstruct mirage-crypto mirage-crypto-rng
                            zarith eqaf-cstruct sexplib0 ];

  doCheck = true;
  checkInputs = [ ounit2 randomconv ];

  meta = mirage-crypto.meta // {
    description = "Simple public-key cryptography for the modern age";
  };
}
