{
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  isPy27,
  lib,
  setuptools,
  setuptools-declarative-requirements,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-helpers-namespace";
  version = "2021.12.29";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eSA4JH4AIb65Zqfqbjpw/1/Punfrcsbsj9Yoevhxw1s=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-declarative-requirements
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_helpers_namespace" ];

  meta = with lib; {
    homepage = "https://github.com/saltstack/pytest-helpers-namespace";
    description = "PyTest Helpers Namespace";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
