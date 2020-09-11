{ stdenv, fetchPypi, buildPythonPackage, pycodestyle, glibcLocales
, toml
}:

buildPythonPackage rec {
  pname = "autopep8";
  version = "1.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d21d3901cb0da6ebd1e83fc9b0dfbde8b46afc2ede4fe32fbda0c7c6118ca094";
  };

  propagatedBuildInputs = [ pycodestyle toml ];

  # One test fails:
  # FAIL: test_recursive_should_not_crash_on_unicode_filename (test.test_autopep8.CommandLineTests)
#   doCheck = false;

  checkInputs = [ glibcLocales ];

  LC_ALL = "en_US.UTF-8";

  meta = with stdenv.lib; {
    description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = "https://pypi.python.org/pypi/autopep8/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
  };
}
