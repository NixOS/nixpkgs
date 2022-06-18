{ lib
, buildPythonPackage
, fetchPypi
, importlib-resources
, importlib-metadata
, iso3166
, pycountry
, pytestCheckHook
, pytest-cov
, pythonOlder
}:

buildPythonPackage rec {
  pname = "schwifty";
  version = "2022.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-d3V+pkq+gAWx6vAC5SDELscks+7a+fAFh31pwsCCSZU=";
  };

  propagatedBuildInputs = [
    iso3166
    pycountry
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-metadata
  ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "schwifty"
  ];

  meta = with lib; {
    description = "Validate/generate IBANs and BICs";
    homepage = "https://github.com/mdomke/schwifty";
    license = licenses.mit;
    maintainers = with maintainers; [ milibopp ];
  };
}
