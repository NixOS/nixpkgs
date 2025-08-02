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
  version = "2025.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "python-drafthorse";
    rev = version;
    hash = "sha256-zKFKZIF50qAYzLhyCWMfrgaf9YRpk1MU81DAWaycXFI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    pypdf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "drafthorse" ];

  meta = {
    description = "Pure-python ZUGFeRD implementation";
    homepage = "https://github.com/pretix/python-drafthorse";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
