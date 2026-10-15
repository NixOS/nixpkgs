{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "pytweening";
  version = "1.2.0";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-JDMYt3NmmAZsXzYuxcK2Q07PQpfDyOfKqKv+avTKxxs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pytweening" ];

  unittestFlags = [
    "-s"
    "tests"
    "-p"
    "basicTests.py"
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Set of tweening / easing functions implemented in Python";
    homepage = "https://github.com/asweigart/pytweening";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
