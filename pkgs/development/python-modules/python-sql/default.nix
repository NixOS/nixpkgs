{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "python_sql";
    inherit version;
    hash = "sha256-93RnHx0IT6a6Q4mJJM3r5O0NAHHfjWCAQKzU8cjYaqM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sql" ];

  meta = with lib; {
    description = "Library to write SQL queries in a pythonic way";
    homepage = "https://foss.heptapod.net/tryton/python-sql";
    changelog = "https://foss.heptapod.net/tryton/python-sql/-/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ johbo ];
  };
}
