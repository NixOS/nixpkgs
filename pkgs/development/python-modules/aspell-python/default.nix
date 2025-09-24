{
  lib,
  aspell,
  aspellDicts,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aspell-python";
  version = "1.15";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    pname = "aspell-python-py3";
    inherit version;
    extension = "tar.bz2";
    hash = "sha256-IEKRDmQY5fOH9bQk0dkUAy7UzpBOoZW4cNtVvLMcs40=";
  };

  build-system = [ setuptools ];

  buildInputs = [ aspell ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export ASPELL_CONF="dict-dir ${aspellDicts.en}/lib/aspell"
    export HOME=$(mktemp -d)
  '';

  enabledTestPaths = [ "test/unittests.py" ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/WojciechMula/aspell-python/issues/22
    "test_add"
    "test_get"
    "test_saveall"
  ];

  pythonImportsCheck = [ "aspell" ];

  meta = with lib; {
    description = "Python wrapper for aspell (C extension and Python version)";
    homepage = "https://github.com/WojciechMula/aspell-python";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
