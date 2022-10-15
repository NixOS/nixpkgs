{ lib
, attrs
, buildPythonPackage
, fetchPypi
, hatch-fancy-pypi-readme
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
  version = "4.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FlBZ8Hbv9pcbrlt0L8App7TvP5vPBMFOR3anYF3hSyM=";
  };

  postPatch = ''
    patchShebangs json/bin/jsonschema_suite
  '';

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
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
