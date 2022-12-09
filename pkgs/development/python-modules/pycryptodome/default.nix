{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, fetchpatch
, cffi
, gmp
}:

let
  test-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "pycryptodome";
  version = "3.15.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Legrandin";
    repo = "pycryptodome";
    rev = "v${version}";
    hash = "sha256-SPRoAfwP1MFlVzZsVWmXDWUY5Yje7eg7d+9zJhZNXrw=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Legrandin/pycryptodome/commit/1c043abb089ddbc2fc43d1c169672688ccc64c64.patch";
      sha256 = "sha256-QklwOlFpQNAH0CpR06fWSZqx8C97RV8BRsKbp2j8js8=";
    })
  ];

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
