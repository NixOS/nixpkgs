{ lib, fetchurl, buildDunePackage, fetchpatch
, alcotest, cstruct-unix
, asn1-combinators, domain-name, fmt, gmap, rresult, mirage-crypto, mirage-crypto-pk
, logs, base64
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";

  pname = "x509";
  version = "0.11.2";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/v${version}/x509-v${version}.tbz";
    sha256 = "1b4lcphmlyjhdgqi0brakgjp3diwmrj1y9hx87svi5xklw3zik22";
  };

  patches = [
    # fix tests for mirage-crypto >= 0.8.9, can be removed at next release
    (fetchpatch {
      url = "https://github.com/mirleft/ocaml-x509/commit/ba1fdd4432950293e663416a0c454c8c04a71c0f.patch";
      sha256 = "1rbjf7408772ns3ypk2hyw9v17iy1kcx84plr1rqc56iwk9zzxmr";
    })
  ];

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
