{ lib, fetchurl, buildDunePackage
, alcotest, cstruct-unix
, asn1-combinators, domain-name, fmt, gmap, pbkdf, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk, ipaddr
, logs, base64
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";

  pname = "x509";
  version = "0.16.0";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/v${version}/x509-${version}.tbz";
    sha256 = "sha256:159mhfwsiv08sj0zk7s3k813f0mc9vpziwpf6j9r32y3nizp59k7";
  };

  checkInputs = [ alcotest cstruct-unix ];
  propagatedBuildInputs = [ asn1-combinators domain-name fmt gmap mirage-crypto mirage-crypto-pk mirage-crypto-ec pbkdf logs base64 ipaddr ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-x509";
    description = "X509 (RFC5280) handling in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vbgl ];
  };
}
