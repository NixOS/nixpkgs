{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytimeparse";
  version = "1.1.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6GE2R3vpJNfmcGRqmFYZV+jKcwjUSEHiH13ep1dVago=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "pytimeparse/tests/testtimeparse.py" ];

  pythonImportsCheck = [ "pytimeparse" ];

  meta = {
    description = "Library to parse various kinds of time expressions";
    homepage = "https://github.com/wroberts/pytimeparse";
    changelog = "https://github.com/wroberts/pytimeparse/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
