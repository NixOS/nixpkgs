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
<<<<<<< HEAD
  version = "3.18.0";
=======
  version = "3.17.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Legrandin";
    repo = "pycryptodome";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-6oXXy18KlSjfyZhfMnIgnu34u/9sG0TPYvPJ8ovTqMA=";
=======
    rev = "v${version}";
    hash = "sha256-xsfd+dbaNOPuD0ulvpLPBPtcFgmJqX1VuunwNMcqh+Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/Legrandin/pycryptodome/blob/v${version}/Changelog.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ bsd2 /* and */ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
