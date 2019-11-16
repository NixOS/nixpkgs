{ lib, buildPythonPackage, fetchPypi, python, isPy27
, attrs
, functools32
, importlib-metadata
, mock
, nose
, pyperf
, pyrsistent
, setuptools_scm
, twisted
, vcversioner
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2fa0684276b6333ff3c0b1b27081f4b2305f0a36cf702a23db50edb141893c3f";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ attrs importlib-metadata functools32 pyrsistent ];
  checkInputs = [ nose mock pyperf twisted vcversioner ];

  # zope namespace collides on py27
  doCheck = !isPy27;
  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = https://github.com/Julian/jsonschema;
    description = "An implementation of JSON Schema validation for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
