{ lib, fetchurl, buildDunePackage, ocaml
, alcotest, cstruct-unix
, asn1-combinators, domain-name, fmt, gmap, nocrypto, rresult
}:

buildDunePackage rec {
  pname = "x509";
  version = "0.7.1";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/v${version}/x509-v${version}.tbz";
    sha256 = "0hnklgdm1fwwqi0nfvpdbp7ddqvrh9h8697mr99bxqdfhg6sxh1w";
  };

  buildInputs = lib.optionals doCheck [ alcotest cstruct-unix ];
  propagatedBuildInputs = [ asn1-combinators domain-name fmt gmap nocrypto rresult ];

  doCheck = lib.versionAtLeast ocaml.version "4.06";

  meta = with lib; {
    homepage = https://github.com/mirleft/ocaml-x509;
    description = "X509 (RFC5280) handling in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vbgl ];
  };
}
