{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "23.12.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AFadgurvvGpJCjEb+oSpxXHP+d2/iwpPTntPhotK2SU=";
  };

  propagatedBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    importlib-metadata
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pycountry"
  ];

  meta = with lib; {
    homepage = "https://github.com/flyingcircusio/pycountry";
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
  };

}
