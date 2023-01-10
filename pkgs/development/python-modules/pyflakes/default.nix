{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "3.0.1";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7IsnamtgvYDe/tJa3X5DmIHBnmSFCv2bNGKD1BZf0P0=";
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
