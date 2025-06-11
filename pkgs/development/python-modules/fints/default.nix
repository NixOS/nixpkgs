{
  lib,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  fetchFromGitHub,
  bleach,
  mt-940,
  requests,
  sepaxml,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  version = "4.2.3";
  pname = "fints";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    tag = "v${version}";
    hash = "sha256-QR5/mAll6vuP+hJo/oguynLLsGawhTQNaU6TCgww9yM=";
  };

  pythonRemoveDeps = [ "enum-tools" ];

  build-system = [ setuptools ];

  dependencies = [
    bleach
    mt-940
    requests
    sepaxml
  ];

  pythonImportsCheck = [ "fints" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    homepage = "https://github.com/raphaelm/python-fints/";
    description = "Pure-python FinTS (formerly known as HBCI) implementation";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      dotlambda
    ];
  };
}
