{
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  lib,
  setuptools,
  setuptools-declarative-requirements,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-helpers-namespace";
  version = "2021.12.29";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-eSA4JH4AIb65Zqfqbjpw/1/Punfrcsbsj9Yoevhxw1s=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-declarative-requirements
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_helpers_namespace" ];

  meta = {
    homepage = "https://github.com/saltstack/pytest-helpers-namespace";
    description = "PyTest Helpers Namespace";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
