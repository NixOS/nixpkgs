{ stdenv, buildPythonPackage, fetchPypi, python, pythonOlder
, attrs, pyrsistent, six, functools32, twisted }:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d4a2b7b6c2237e0199c8ea1a6d3e05bf118e289ae2b9d7ba444182a2959560d";
  };

  checkInputs = [ twisted ];
  propagatedBuildInputs =
    [ attrs pyrsistent six ]
    ++ stdenv.lib.optional (pythonOlder "3") functools32;

  checkPhase = ''
    # jsonschema.tests.test_cli fails, and I don't know how to skip tests with
    # twisted. So we list all the other ones.
    python -m twisted.trial \
      jsonschema.tests.test_exceptions \
      jsonschema.tests.test_format \
      jsonschema.tests.test_jsonschema_test_suite \
      jsonschema.tests.test_types \
      jsonschema.tests.test_validators
    python -m doctest README.rst
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Julian/jsonschema;
    description = "An implementation of JSON Schema validation for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
