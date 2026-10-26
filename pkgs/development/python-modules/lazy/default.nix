{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lazy";
  version = "2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+S7A0y3WvRFd3sTjMjRz68C2gq1Yxqynjr/Z5tGqV3c=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lazy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Lazy attributes for Python objects";
    license = lib.licenses.bsd2;
    homepage = "https://github.com/stefanholek/lazy";
  };
})
