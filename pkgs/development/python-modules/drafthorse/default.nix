{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  pypdf,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "drafthorse";
  version = "2025.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "python-drafthorse";
    rev = version;
    hash = "sha256-z8w1n/rjrVpL+3MFoTaKCI7NZpchIg4H80rNlm0sFgQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    pypdf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "drafthorse" ];

  meta = with lib; {
    description = "Pure-python ZUGFeRD implementation";
    homepage = "https://github.com/pretix/python-drafthorse";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
