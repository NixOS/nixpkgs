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
  version = "0.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "asdf_transform_schemas";
    inherit version;
    hash = "sha256-9xqTCe0+vQmxk3roV8lM7JKIeHBEDrPphou77XJlaxU=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
