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
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "schwifty";
  version = "2023.11.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lyyAx8VDIRO72xW64gjcsZw2C31hV3YCLIGSmdlIJeI=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

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
