{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, python
, attrs
, importlib-metadata
, importlib-resources
, nose
, pyperf
, pyrsistent
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "4.2.1";

  disabled = pythonOlder "3.7";
  dontPreferSetupPy = true;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OQcTRprmS4pYaYuzy8OFmr5pJbVlqXP4cyPvIbCaJ6g=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ attrs pyrsistent ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ]
    ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  checkInputs = [ nose pyperf ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://github.com/Julian/jsonschema";
    description = "An implementation of JSON Schema validation for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
