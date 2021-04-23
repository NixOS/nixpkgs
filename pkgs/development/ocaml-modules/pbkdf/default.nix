{ lib
, buildDunePackage
, fetchurl
, mirage-crypto
, alcotest
}:

buildDunePackage rec {
  pname = "pbkdf";
  version = "1.1.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/abeaumont/ocaml-pbkdf/releases/download/${version}/pbkdf-${version}.tbz";
    sha256 = "e53ed1bd9abf490c858a341c10fb548bc9ad50d4479acdf95a9358a73d042264";
  };

  propagatedBuildInputs = [ mirage-crypto ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    description = "Password based key derivation functions (PBKDF) from PKCS#5";
    maintainers = [ lib.maintainers.sternenseemann ];
    license = lib.licenses.bsd2;
    homepage = "https://github.com/abeaumont/ocaml-pbkdf";
  };
}

