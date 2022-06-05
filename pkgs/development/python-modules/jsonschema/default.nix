{ lib
, attrs
, buildPythonPackage
, fetchPypi
, importlib-metadata
, importlib-resources
, pyrsistent
, pythonOlder
, setuptools-scm
, twisted
, typing-extensions
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "4.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fG2IJhk0DDNHob9zFeFH5tPa5DkDOuY4PWrLkIwQHfw=";
  };

  postPatch = ''
    patchShebangs json/bin/jsonschema_suite
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
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
