{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "3.1.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oKrgNMRE2wBxqgd5crpHaNQMgw2VOf1Fv0zT+PaZLvw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyflakes" ];

  meta = with lib; {
    homepage = "https://github.com/PyCQA/pyflakes";
    changelog = "https://github.com/PyCQA/pyflakes/blob/${version}/NEWS.rst";
    description = "A simple program which checks Python source files for errors";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
