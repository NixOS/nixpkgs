{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  anyio,
  pytest-asyncio,
  pytest-tornasync,
  pytest-trio,
  pytest-twisted,
  twisted,
}:

buildPythonPackage (finalAttrs: {
  pname = "dimi";
  version = "1.5.0";
  format = "pyproject";
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-eJ9y1gGx3aCqJ1Q5+/7PPvJ9oiUYB6HyggK63bK/DTw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "dimi" ];

  nativeCheckInputs = [
    pytestCheckHook
    anyio
    pytest-asyncio
    pytest-tornasync
    pytest-trio
    pytest-twisted
    twisted
  ];

  # TODO investigate, seams to require some fixtures, not sure where to get them from
  disabledTestPaths = [
    "tests/test_di.py"
    "tests/test_integrations.py"
    "tests/test_use_cases.py"
    "tests/test_utils.py"
  ];

  meta = {
    description = "Minimalistic Dependency Injection for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
