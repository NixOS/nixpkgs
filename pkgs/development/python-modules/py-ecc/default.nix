{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cached-property,
  eth-typing,
  eth-utils,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  pydantic,
}:

buildPythonPackage rec {
  pname = "py-ecc";
  version = "8.0.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "py_ecc";
    rev = "v${version}";
    hash = "sha256-4nmmX4TuErHxIDrBi+Ppr+4vuE7dSeqf8OqOxtqb3sY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cached-property
    eth-typing
    eth-utils
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pydantic
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # https://github.com/ethereum/py_ecc/issues/133
    "test_FQ2_object"
    "test_pairing_bilinearity_on_G1"
    "test_pairing_bilinearity_on_G2"
    "test_pairing_composit_check"
    "test_pairing_is_non_degenerate"
    "test_pairing_negative_G1"
    "test_pairing_negative_G2"
    "test_pairing_output_order"
    "test_install_local_wheel"
  ];

  pythonImportsCheck = [ "py_ecc" ];

  meta = with lib; {
    changelog = "https://github.com/ethereum/py_ecc/blob/${src.rev}/CHANGELOG.rst";
    description = "ECC pairing and bn_128 and bls12_381 curve operations";
    homepage = "https://github.com/ethereum/py_ecc";
    license = licenses.mit;
    maintainers = [ ];
  };
}
