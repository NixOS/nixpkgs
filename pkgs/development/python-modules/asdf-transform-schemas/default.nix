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
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "asdf_transform_schemas";
    inherit version;
    hash = "sha256-DPL/eyLMtAj+WN3ZskQaWbpz/jI+QW1ZueCkcop9LdY=";
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
