{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytest
, pysha3
, safe-pysha3
, pycryptodome
}:

buildPythonPackage rec {
  pname = "eth-hash";
  version = "0.3.2";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-hash";
    rev = "v${version}";
    sha256 = "sha256-LMDtFUrsPYgj/Fl9aBW1todlj1D3LlFxAkzNFAzCGLQ=";
  };

  nativeCheckInputs = [
    pytest
  ] ++ passthru.optional-dependencies.pycryptodome
  ++ passthru.optional-dependencies.pysha3;

  checkPhase = ''
    pytest tests/backends/pycryptodome/
    pytest tests/backends/pysha3/
  '';

  passthru.optional-dependencies = {
    pycryptodome = [ pycryptodome ];
    pysha3 = if pythonOlder "3.9" then [ pysha3 ] else [ safe-pysha3 ];
  };

  meta = with lib; {
    description = "The Ethereum hashing function keccak256";
    homepage = "https://github.com/ethereum/eth-hash";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
