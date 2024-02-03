{ lib
, asdf-standard
, buildPythonPackage
, fetchPypi
, importlib-resources
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "asdf-transform-schemas";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "asdf_transform_schemas";
    inherit version;
    hash = "sha256-3n/cP+41+5V/wylXh3oOnX3U0uhRvWMaclnxHCvSlMo=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    asdf-standard
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  # Circular dependency on asdf
  doCheck = false;

  pythonImportsCheck = [
    "asdf_transform_schemas"
  ];

  meta = with lib; {
    description = "ASDF schemas for validating transform tags";
    homepage = "https://github.com/asdf-format/asdf-transform-schemas";
    changelog = "https://github.com/asdf-format/asdf-transform-schemas/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
