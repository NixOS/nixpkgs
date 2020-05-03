{ lib, fetchurl, buildDunePackage
, alcotest, cstruct-unix
, asn1-combinators, domain-name, fmt, gmap, rresult, mirage-crypto, mirage-crypto-pk
, logs, base64
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";

  pname = "x509";
  version = "0.11.1";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/v${version}/x509-v${version}.tbz";
    sha256 = "1vmjqwmxf7zz157rlp3wp3zp88kw62m4f22i0xmxhinssd0dvr9c";
  };

  useDune2 = true;

  buildInputs = [ alcotest cstruct-unix ];
  propagatedBuildInputs = [ asn1-combinators domain-name fmt gmap mirage-crypto mirage-crypto-pk rresult  logs base64 ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-x509";
    description = "X509 (RFC5280) handling in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vbgl ];
  };
}
