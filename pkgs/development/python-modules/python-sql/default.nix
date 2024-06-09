{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-sql";
  version = "1.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YmC+/4NaNdOgrsTx2jUbC+nKoaDZSmy6lAp82Nz2Ymk=";
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
