{ stdenv, buildPythonPackage, fetchPypi, python
, nose, mock, vcversioner, functools32, setuptools_scm, attrs, pyrsistent, twisted, perf }:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03anb4ljl624lixrsaxfi7i1iwavw39sd8cfkhcy0dr2dixjnjld";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ nose mock vcversioner twisted perf ];
  propagatedBuildInputs = [ functools32 attrs pyrsistent ];

  postPatch = ''
    substituteInPlace jsonschema/tests/test_jsonschema_test_suite.py \
      --replace "python" "${python.pythonForBuild.interpreter}"
  '';

  checkPhase = ''
    nosetests
  '';

  /*
  ERROR: jsonschema.tests.test_validators.test_Draft7Validator_date_ignores_non_strings
  ----------------------------------------------------------------------
  Traceback (most recent call last):
    File "/nix/store/72gfj2iqmi6pb0b4xsxafmsjj2fnr2hg-python3.7-nose-1.3.7/lib/python3.7/site-packages/nose/case.py", line 197, in runTest
      self.test(*self.arg)
  TypeError: test() missing 1 required positional argument: 'self'
  */
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/Julian/jsonschema;
    description = "An implementation of JSON Schema validation for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
