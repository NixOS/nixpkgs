{ lib, fetchurl, buildDunePackage
, alcotest, cstruct-unix
, asn1-combinators, domain-name, fmt, gmap, pbkdf, rresult, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk
, logs, base64
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";

  pname = "x509";
  version = "0.12.0";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/v${version}/x509-v${version}.tbz";
    sha256 = "04g59j8sn8am0z0a94h8cyvr6cqzd5gkn2lj6g51nb5dkwajj19h";
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
