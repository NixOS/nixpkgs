{ buildDunePackage, ounit, randomconv, mirage-crypto, mirage-crypto-rng
, cstruct, sexplib, ppx_sexp_conv, zarith, eqaf, rresult, gmp }:

buildDunePackage {
  pname = "mirage-crypto-pk";

  inherit (mirage-crypto) version src useDune2 minimumOCamlVersion;

  buildInputs = [ gmp ];
  propagatedBuildInputs = [ cstruct mirage-crypto mirage-crypto-rng
                            zarith eqaf rresult sexplib ppx_sexp_conv ];

  doCheck = true;
  checkInputs = [ ounit randomconv ];

  meta = mirage-crypto.meta // {
    description = "Simple public-key cryptography for the modern age";
  };
}
