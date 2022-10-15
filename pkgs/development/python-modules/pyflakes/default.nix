{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "2.5.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "491feb020dca48ccc562a8c0cbe8df07ee13078df59813b83959cbdada312ea3";
  };

  checkInputs = [
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
