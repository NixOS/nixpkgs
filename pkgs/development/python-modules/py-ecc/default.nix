{ lib
, buildPythonPackage
, fetchFromGitHub
, cached-property
, eth-typing
, eth-utils
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "py-ecc";
  version = "7.0.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "py_ecc";
    rev = "v${version}";
    hash = "sha256-DKe+bI1GEzXg4Y4n5OA1/hWYz9L3X1AvaOFPEnCaAfs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cached-property
    eth-typing
    eth-utils
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "py_ecc" ];

  meta = with lib; {
    changelog = "https://github.com/ethereum/py_ecc/blob/${src.rev}/CHANGELOG.rst";
    description = "ECC pairing and bn_128 and bls12_381 curve operations";
    homepage = "https://github.com/ethereum/py_ecc";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
