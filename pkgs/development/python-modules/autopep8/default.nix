{ stdenv, fetchPypi, buildPythonPackage, pycodestyle }:

buildPythonPackage rec {
  pname = "autopep8";
  version = "1.3.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7be71ab0cb2f50c9c22c82f0c9acaafc6f57492c3fbfee9790c415005c2b9a5";
  };

  propagatedBuildInputs = [ pycodestyle ];

  # One test fails:
  # FAIL: test_recursive_should_not_crash_on_unicode_filename (test.test_autopep8.CommandLineTests)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = https://pypi.python.org/pypi/autopep8/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
  };
}
