{
  lib,
  pythonOlder,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  flake8,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flake8-deprecated";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "flake8_deprecated";
    inherit version;
    hash = "sha256-7pbKAB0coFYfqORvI+LSRgsYqGaWNzyrZE4QKuD/KqI=";
  };

  build-system = [ hatchling ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "run_tests.py" ];

  pythonImportsCheck = [ "flake8_deprecated" ];

  meta = with lib; {
    description = "Flake8 plugin that warns about deprecated method calls";
    homepage = "https://github.com/gforcada/flake8-deprecated";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
