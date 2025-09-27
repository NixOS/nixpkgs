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
  version = "4.2.4";
  pname = "fints";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    tag = "v${version}";
    hash = "sha256-la5vpWBoZ7hZsAyjjCqHpFfOykDVosI/S9amox1dmzY=";
  };

  pythonRemoveDeps = [ "enum-tools" ];

  build-system = [ setuptools ];

  dependencies = [
    bleach
    mt-940
    requests
    sepaxml
  ];

  __darwinAllowLocalNetworking = true;

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
