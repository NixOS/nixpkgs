{ lib
, buildDunePackage
, fetchFromGitHub
, cstruct
, mirage-crypto
, alcotest
}:

buildDunePackage rec {
  pname = "pbkdf";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "abeaumont";
    repo = "ocaml-${pname}";
    rev = version;
    sha256 = "sha256-dGi4Vw+7VBpK/NpJ6zdpogm+E6G/oJovXCksJBSmqjI=";
  };

  propagatedBuildInputs = [ mirage-crypto ];
  buildInputs = [ cstruct ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    description = "Password based key derivation functions (PBKDF) from PKCS#5";
    maintainers = [ lib.maintainers.sternenseemann ];
    license = lib.licenses.bsd2;
    homepage = "https://github.com/abeaumont/ocaml-pbkdf";
  };
}

