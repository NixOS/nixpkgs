{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  # dependencies
  eth-typing,
  eth-utils,
  # nativeCheckInputs
  asn1tools,
  factory-boy,
  hypothesis,
  pyasn1,
  pytestCheckHook,
  coincurve,
  eth-hash,
  isPyPy,
  pydantic,
}:

buildPythonPackage rec {
  pname = "eth-keys";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-keys";
    tag = "v${version}";
    hash = "sha256-H/s/D4f4tqP/WTil9uLmFw2Do9sEjMWwEreQEooeszQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    eth-typing
    eth-utils
  ];

  nativeCheckInputs = [
    asn1tools
    factory-boy
    hypothesis
    pyasn1
    pytestCheckHook
    pydantic
  ]
  ++ optional-dependencies.coincurve
  ++ lib.optional (!isPyPy) eth-hash.optional-dependencies.pysha3
  ++ lib.optional isPyPy eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_keys" ];

  disabledTests = [ "test_install_local_wheel" ];

  optional-dependencies = {
    coincurve = [ coincurve ];
  };

  meta = {
    description = "Common API for Ethereum key operations";
    homepage = "https://github.com/ethereum/eth-keys";
    changelog = "https://github.com/ethereum/eth-keys/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
