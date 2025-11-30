{
  lib,
  buildPythonPackage,
  cogapp,
  fetchPypi,
  mock,
  setuptools,
  pytestCheckHook,
  pythonOlder,
  six,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "paver";
  version = "1.3.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Paver";
    inherit version;
    hash = "sha256-0+ZJiIFIWrdQ7+QMUniYKpNDvGJ+E3sRrc7WJ3GTCMc=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  checkInputs = [
    cogapp
    mock
    pytestCheckHook
    virtualenv
  ];

  pythonImportsCheck = [ "paver" ];

  disabledTestPaths = [
    # Tests depend on distutils
    "paver/tests/test_setuputils.py"
    "paver/tests/test_doctools.py"
    "paver/tests/test_tasks.py"
  ];

  meta = {
    description = "Python-based build/distribution/deployment scripting tool";
    mainProgram = "paver";
    homepage = "https://github.com/paver/paver";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovek323 ];
  };
}
