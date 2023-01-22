{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b+dkCC9IiR2Ffqfm+kJfpU8TUx3fa4nyTAmOZGrRtLY=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sql"
  ];

  meta = with lib; {
    description = "Library to write SQL queries in a pythonic way";
    homepage = "https://pypi.org/project/python-sql/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ johbo ];
  };
}
