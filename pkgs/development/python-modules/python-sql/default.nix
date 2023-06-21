{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KkcvQLQPlFmdBi6/92BHm2NTX2LQLrnH1nGR4Iq/ctw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sql"
  ];

  meta = with lib; {
    description = "Library to write SQL queries in a pythonic way";
    homepage = "https://foss.heptapod.net/tryton/python-sql";
    changelog = "https://foss.heptapod.net/tryton/python-sql/-/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ johbo ];
  };
}
