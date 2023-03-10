{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, gmp
}:

let
  test-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "pycryptodome";
  version = "3.17.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Legrandin";
    repo = "pycryptodome";
    rev = "v${version}";
    hash = "sha256-xsfd+dbaNOPuD0ulvpLPBPtcFgmJqX1VuunwNMcqh+Q=";
  };

  postPatch = ''
    substituteInPlace lib/Crypto/Math/_IntegerGMP.py \
      --replace 'load_lib("gmp"' 'load_lib("${gmp}/lib/libgmp.so.10"'
  '';

  nativeCheckInputs = [
    test-vectors
  ];

  pythonImportsCheck = [
    "Crypto"
  ];

  meta = with lib; {
    description = "Self-contained cryptographic library";
    homepage = "https://github.com/Legrandin/pycryptodome";
    license = with licenses; [ bsd2 /* and */ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
