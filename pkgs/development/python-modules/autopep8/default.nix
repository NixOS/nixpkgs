{ lib, fetchPypi, buildPythonPackage, pycodestyle, glibcLocales
, toml
}:

buildPythonPackage rec {
  pname = "autopep8";
  version = "1.5.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "276ced7e9e3cb22e5d7c14748384a5cf5d9002257c0ed50c0e075b68011bb6d0";
  };

  propagatedBuildInputs = [ pycodestyle toml ];

  # One test fails:
  # FAIL: test_recursive_should_not_crash_on_unicode_filename (test.test_autopep8.CommandLineTests)
#   doCheck = false;

  checkInputs = [ glibcLocales ];

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = "https://pypi.python.org/pypi/autopep8/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
  };
}
