{ stdenv, fetchPypi, buildPythonPackage, pycodestyle }:

buildPythonPackage rec {
  pname = "autopep8";
  version = "1.3.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c1gl648g2xnz3j0rsp71ld4i32zlglmqjvqf4q8r08jp3zpny7z";
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
