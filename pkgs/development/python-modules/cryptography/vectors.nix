<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, setuptools
}:
=======
{ buildPythonPackage, fetchPypi, lib, cryptography }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "cryptography-vectors";
  # The test vectors must have the same version as the cryptography package
  inherit (cryptography) version;
<<<<<<< HEAD
  format = "pyproject";
=======
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "cryptography_vectors";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-gN4EUsSzT1b1UY6B69dba5BfVyiq7VIdQuQfTryKQ/s=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [
    "cryptography_vectors"
  ];
=======
    hash = "sha256-hGBwa1tdDOSoVXHKM4nPiPcAu2oMYTPcn+D1ovW9oEE=";
  };

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "cryptography_vectors" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Test vectors for the cryptography package";
    homepage = "https://cryptography.io/en/latest/development/test-vectors/";
<<<<<<< HEAD
    downloadPage = "https://github.com/pyca/cryptography/tree/master/vectors";
=======
    # Source: https://github.com/pyca/cryptography/tree/master/vectors;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
