{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonAtLeast
, pythonOlder
, pytest
, safe-pysha3
, pycryptodome
}:

buildPythonPackage rec {
  pname = "eth-hash";
  version = "0.5.2";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-hash";
    rev = "v${version}";
    hash = "sha256-6UN+kvLjjAtkmLgUaovjZC/6n3FZtXCwyXZH7ijQObU=";
  };

  nativeCheckInputs = [
    pytest
  ] ++ passthru.optional-dependencies.pycryptodome
  # eth-hash can use either safe-pysha3 or pycryptodome;
  # safe-pysha3 requires Python 3.9+ while pycryptodome does not.
  # https://github.com/ethereum/eth-hash/issues/46#issuecomment-1314029211
  ++ lib.optional (pythonAtLeast "3.9") passthru.optional-dependencies.pysha3;

  checkPhase = ''
    pytest tests/backends/pycryptodome/
  '' + lib.optionalString (pythonAtLeast "3.9") ''
    pytest tests/backends/pysha3/
  '';

  passthru.optional-dependencies = {
    pycryptodome = [ pycryptodome ];
    pysha3 = [ safe-pysha3 ];
  };

  meta = with lib; {
    description = "The Ethereum hashing function keccak256";
    homepage = "https://github.com/ethereum/eth-hash";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
