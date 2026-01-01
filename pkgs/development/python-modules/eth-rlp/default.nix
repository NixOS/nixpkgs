{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  eth-hash,
  eth-utils,
  hexbytes,
  pytestCheckHook,
  pythonOlder,
  rlp,
  pydantic,
}:

buildPythonPackage rec {
  pname = "eth-rlp";
  version = "2.2.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-rlp";
    rev = "v${version}";
    hash = "sha256-e8nPfxk3OnFEcPnfTy1IEUCHVId6E/ssNOUeAe331+U=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    hexbytes
    eth-utils
    rlp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pydantic
  ]
  ++ eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_rlp" ];

  disabledTests = [
    "test_install_local_wheel"
  ];

<<<<<<< HEAD
  meta = {
    description = "RLP definitions for common Ethereum objects";
    homepage = "https://github.com/ethereum/eth-rlp";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "RLP definitions for common Ethereum objects";
    homepage = "https://github.com/ethereum/eth-rlp";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
