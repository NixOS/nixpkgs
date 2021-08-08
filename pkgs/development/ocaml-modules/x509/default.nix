{ lib, fetchurl, buildDunePackage
, alcotest, cstruct-unix
, asn1-combinators, domain-name, fmt, gmap, pbkdf, rresult, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk
, logs, base64
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";

  pname = "x509";
  version = "0.14.0";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/v${version}/x509-v${version}.tbz";
    sha256 = "9b42f34171261b2193ee662f096566c48c48e087949c186c288f90c9b3b9f498";
  };

  useDune2 = true;

  buildInputs = [ alcotest cstruct-unix ];
  propagatedBuildInputs = [ asn1-combinators domain-name fmt gmap mirage-crypto mirage-crypto-pk mirage-crypto-ec pbkdf rresult logs base64 ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-x509";
    description = "X509 (RFC5280) handling in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vbgl ];
  };
}
