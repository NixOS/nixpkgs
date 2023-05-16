{ lib
, fetchFromGitHub
, buildPythonPackage
<<<<<<< HEAD
, pythonAtLeast
, pythonOlder
, pytest
=======
, pythonOlder
, pytest
, pysha3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, safe-pysha3
, pycryptodome
}:

buildPythonPackage rec {
  pname = "eth-hash";
<<<<<<< HEAD
  version = "0.5.2";
=======
  version = "0.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-hash";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6UN+kvLjjAtkmLgUaovjZC/6n3FZtXCwyXZH7ijQObU=";
=======
    hash = "sha256-LMDtFUrsPYgj/Fl9aBW1todlj1D3LlFxAkzNFAzCGLQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytest
  ] ++ passthru.optional-dependencies.pycryptodome
<<<<<<< HEAD
  # eth-hash can use either safe-pysha3 or pycryptodome;
  # safe-pysha3 requires Python 3.9+ while pycryptodome does not.
  # https://github.com/ethereum/eth-hash/issues/46#issuecomment-1314029211
  ++ lib.optional (pythonAtLeast "3.9") passthru.optional-dependencies.pysha3;

  checkPhase = ''
    pytest tests/backends/pycryptodome/
  '' + lib.optionalString (pythonAtLeast "3.9") ''
=======
  ++ passthru.optional-dependencies.pysha3;

  checkPhase = ''
    pytest tests/backends/pycryptodome/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest tests/backends/pysha3/
  '';

  passthru.optional-dependencies = {
    pycryptodome = [ pycryptodome ];
<<<<<<< HEAD
    pysha3 = [ safe-pysha3 ];
=======
    pysha3 = if pythonOlder "3.9" then [ pysha3 ] else [ safe-pysha3 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "The Ethereum hashing function keccak256";
    homepage = "https://github.com/ethereum/eth-hash";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
