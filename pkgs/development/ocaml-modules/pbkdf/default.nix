{ lib
, buildDunePackage
, fetchzip
, cstruct
, mirage-crypto
, alcotest
}:

buildDunePackage rec {
  pname = "pbkdf";
  version = "1.2.0";

  src = fetchzip {
    url = "https://github.com/abeaumont/ocaml-pbkdf/archive/${version}.tar.gz";
    sha256 = "sha256-dGi4Vw+7VBpK/NpJ6zdpogm+E6G/oJovXCksJBSmqjI=";
  };

  minimalOCamlVersion = "4.07";
  propagatedBuildInputs = [ cstruct mirage-crypto ];
  nativeCheckInputs = [ alcotest ];
  doCheck = true;

  meta = {
    description = "Password based key derivation functions (PBKDF) from PKCS#5";
    maintainers = [ lib.maintainers.sternenseemann ];
    license = lib.licenses.bsd2;
    homepage = "https://github.com/abeaumont/ocaml-pbkdf";
  };
}

