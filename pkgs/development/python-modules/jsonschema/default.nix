{ lib
, attrs
, buildPythonPackage
, fetchPypi
, importlib-metadata
, importlib-resources
, pyperf
, pyrsistent
, pytestCheckHook
, pythonOlder
, setuptools-scm
, twisted
, typing-extensions
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "4.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "636694eb41b3535ed608fe04129f26542b59ed99808b4f688aa32dcf55317a83";
  };

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
    pyperf
    pytestCheckHook
    twisted
  ];

  pythonImportsCheck = [
    "jsonschema"
  ];

  meta = with lib; {
    description = "An implementation of JSON Schema validation for Python";
    homepage = "https://github.com/Julian/jsonschema";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
