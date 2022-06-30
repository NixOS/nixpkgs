{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, cffi
, gmp
}:

let
  test-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "pycryptodome";
  version = "3.14.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Legrandin";
    repo = "pycryptodome";
    rev = "v${version}";
    hash = "sha256-0GjpKNyALe2Q1R3dEjeAEn6E8hxYDic/vbN1YkVaUfs=";
  };

  postPatch = ''
    substituteInPlace lib/Crypto/Math/_IntegerGMP.py \
      --replace 'load_lib("gmp"' 'load_lib("${gmp}/lib/libgmp.so.10"'
  '';

  checkInputs = [
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
