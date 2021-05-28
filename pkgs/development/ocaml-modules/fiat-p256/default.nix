{ lib, buildDunePackage, fetchurl, alcotest, asn1-combinators, benchmark
, bigarray-compat, cstruct, eqaf, hex, ppx_deriving_yojson, rresult
, stdlib-shims, yojson, dune-configurator }:

buildDunePackage rec {
  pname = "fiat-p256";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/mirage/fiat/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0086h9qkvnqfm8acrxqbki54z619nj73x7f0d01v5vg2naznx7w9";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ bigarray-compat cstruct eqaf hex ];
  checkInputs = [ alcotest asn1-combinators benchmark
                  ppx_deriving_yojson rresult stdlib-shims yojson ];
  doCheck = true;

  meta = with lib; {
    description = "Primitives for Elliptic Curve Cryptography taken from Fiat";
    homepage = "https://github.com/mirage/fiat";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
