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
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a";
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
