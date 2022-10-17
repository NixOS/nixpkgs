{ lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "contextlib2";
  version = "21.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qx4r/h0B2Wjht+jZAjvFHvNQm7ohe7cwzuOCfh7oKGk=";
  };

  checkInputs = [ unittestCheckHook ];

  pythonImportsCheck = [
    "contextlib2"
  ];

  meta = with lib; {
    description = "Backports and enhancements for the contextlib module";
    homepage = "https://contextlib2.readthedocs.org/";
    license = licenses.psfl;
    maintainers = with maintainers; [ ];
  };
}
