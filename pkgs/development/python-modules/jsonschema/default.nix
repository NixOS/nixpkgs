{ lib
, attrs
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, importlib-metadata
, importlib-resources
, pyrsistent
, pythonOlder
, twisted
, typing-extensions
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "4.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N3ZRLfT1P3Tm4o/jVxe1siPBdWh1SGmEoxvJFl5/ySA=";
  };

  patches = [
    ./remove-fancy-pypi-readme.patch
  ];

  postPatch = ''
    patchShebangs json/bin/jsonschema_suite
  '';

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    pyrsistent
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  checkInputs = [
    twisted
  ];

  checkPhase = ''
    export JSON_SCHEMA_TEST_SUITE=json
    trial jsonschema
  '';

  pythonImportsCheck = [
    "jsonschema"
  ];

  meta = with lib; {
    description = "An implementation of JSON Schema validation for Python";
    homepage = "https://github.com/python-jsonschema/jsonschema";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
