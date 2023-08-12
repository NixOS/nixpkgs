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
  version = "2023.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hDNAoITt2Ak5aVWmMgqg2oA9rDFsiuum5JXc7v7sspU=";
  };

  propagatedBuildInputs = [
    iso3166
    pycountry
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-metadata
  ];

  nativeCheckInputs = [
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
