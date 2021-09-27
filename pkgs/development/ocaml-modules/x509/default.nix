{ lib, fetchFromGitHub, buildDunePackage
, alcotest, cstruct-unix
, asn1-combinators, domain-name, fmt, gmap, pbkdf, rresult, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk
, logs, base64, ipaddr
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";

  pname = "x509";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "mirleft";
    repo = "ocaml-x509";
    rev = "v${version}";
    sha256 = "7QjcGHbsilvy1Kw62t9TDib+92BULyoBiwBwe91GPeY=";
  };

  useDune2 = true;

  buildInputs = [ alcotest cstruct-unix ];
  propagatedBuildInputs = [ asn1-combinators domain-name fmt gmap mirage-crypto mirage-crypto-pk mirage-crypto-ec pbkdf rresult logs base64 ipaddr ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-x509";
    description = "X509 (RFC5280) handling in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vbgl ];
  };
}
