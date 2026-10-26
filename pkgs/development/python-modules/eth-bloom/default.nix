{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  eth-hash,
  # nativeCheckInputs
  hypothesis,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage (finalAttrs: {
  pname = "eth-bloom";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-bloom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WrBLFICPyb+1bIitHZ172A1p1VYqLR75YfJ5/IBqDr8=";
  };

  build-system = [ setuptools ];

  dependencies = [ eth-hash ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-xdist
  ]
  ++ eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_bloom" ];

  disabledTests = [
    # not testable in nix build
    "test_install_local_wheel"
  ];

  meta = {
    description = "Implementation of the Ethereum bloom filter";
    homepage = "https://github.com/ethereum/eth-bloom";
    changelog = "https://github.com/ethereum/eth-bloom/blob/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
})
