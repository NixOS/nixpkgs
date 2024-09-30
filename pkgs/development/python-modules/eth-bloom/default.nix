{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  eth-hash,
  hypothesis,
  pytestCheckHook,
  pytest-xdist,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eth-bloom";
  version = "3.0.1";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-bloom";
    rev = "refs/tags/v${version}";
    hash = "sha256-PmO4HFHAwoj3LQRVWQGndYSGwQ54c+/OkJqYPYtuVNk=";
  };

  build-system = [ setuptools ];

  dependencies = [ eth-hash ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-xdist
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_bloom" ];

  meta = {
    changelog = "https://github.com/ethereum/eth-bloom/blob/v${version}/CHANGELOG.rst";
    description = "Implementation of the Ethereum bloom filter";
    homepage = "https://github.com/ethereum/eth-bloom";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FlorianFranzen ];
  };
}
