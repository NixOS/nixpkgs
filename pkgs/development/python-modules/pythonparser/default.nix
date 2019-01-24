{ lib
, buildPythonPackage
, fetchPypi
, python
, pythonAtLeast
, regex
}:

buildPythonPackage rec {
  pname = "pythonparser";
  version = "1.3";

  # Under 3.7 a couple of tests fail with:
  #   NotImplementedError: pythonparser.lexer.Lexer cannot lex Python (3, 7)
  # Disable for Python 3.7 and above.

  # According to https://github.com/m-labs/pythonparser/issues/20 3.6 support
  # is incomplete, but it does build and test, and can be run under 3.6 to
  # parse 3.5-compatible source.

  disabled = pythonAtLeast "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qby6w2pcfwxi4w62rly08d9wj32amf6m7rmbrqw0xz6mirq7rrp";
  };

  # test_parser tearDownModule writes to non-existent directory
  # It generates a grammar coverage report in ./doc, which exists in git, but
  # not in the pypi package. We do not make use of the report.
  # Remove the report call to be able to run tests successfully.
  patches = [
    ./no_test_parser_teardown.patch
  ];

  propagatedBuildInputs = [
    regex
  ];

  meta = {
    description = "A Python parser intended for use in tooling";
    homepage = https://m-labs.hk/pythonparser;
    downloadPage = https://github.com/m-labs/pythonparser;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clacke ];
  };
}
