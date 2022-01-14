{ lib, buildPythonPackage, fetchPypi, isPy27
, attrs
, functools32
, importlib-metadata
, mock
, nose
, pyperf
, pyrsistent
, setuptools-scm
, twisted
, vcversioner
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "4.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "636694eb41b3535ed608fe04129f26542b59ed99808b4f688aa32dcf55317a83";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ attrs importlib-metadata functools32 pyrsistent ];
  checkInputs = [ nose mock pyperf twisted vcversioner ];

  # zope namespace collides on py27
  doCheck = !isPy27;
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
