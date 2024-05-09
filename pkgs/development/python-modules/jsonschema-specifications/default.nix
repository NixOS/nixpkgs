{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, importlib-resources
, pytestCheckHook
, pythonOlder
, referencing
}:

buildPythonPackage rec {
  pname = "jsonschema-specifications";
  version = "2023.12.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jsonschema_specifications";
    inherit version;
    hash = "sha256-SKdnh7PnD17VPxFg0rgfWG5MptFUjF3nCF0WgmdHZMw=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    referencing
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jsonschema_specifications"
  ];

  meta = with lib; {
    description = "Support files exposing JSON from the JSON Schema specifications";
    homepage = "https://github.com/python-jsonschema/jsonschema-specifications";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
