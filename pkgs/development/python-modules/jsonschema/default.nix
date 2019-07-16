{ lib
, buildPythonPackage
, fetchPypi
, attrs
, pyrsistent
, setuptools
, six
, functools32
, setuptools_scm
, perf
, twisted
, python
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03g20i1xfg4qdlk4475pl4pp7y0h37g1fbgs5qhy678q9xb822hc";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    attrs
    pyrsistent
    setuptools
    six
    functools32
  ];

  checkInputs = [
    twisted
    perf
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test --test-suite=jsonschema.tests
  '';

  meta = with lib; {
    description = "An implementation of JSON Schema validation for Python";
    homepage = https://github.com/Julian/jsonschema;
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc domenkozar ];
  };
}
