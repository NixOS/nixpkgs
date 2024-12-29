{
  lib,
  buildPythonPackage,
  cogapp,
  fetchPypi,
  mock,
  nose,
  pytestCheckHook,
  pythonOlder,
  six,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "paver";
  version = "1.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Paver";
    inherit version;
    hash = "sha256-0+ZJiIFIWrdQ7+QMUniYKpNDvGJ+E3sRrc7WJ3GTCMc=";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [
    cogapp
    mock
    nose
    pytestCheckHook
    virtualenv
  ];

  pythonImportsCheck = [ "paver" ];

  disabledTestPaths = [
    # Test depends on distutils
    "paver/tests/test_setuputils.py"
  ];

  meta = with lib; {
    description = "Python-based build/distribution/deployment scripting tool";
    mainProgram = "paver";
    homepage = "https://github.com/paver/paver";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
  };
}
