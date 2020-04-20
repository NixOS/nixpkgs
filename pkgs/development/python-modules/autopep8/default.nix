{ stdenv, fetchPypi, buildPythonPackage, pycodestyle, glibcLocales }:

buildPythonPackage rec {
  pname = "autopep8";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1swr8ccm3mafcm3zpbwyn22kjs39lbqmg8w41sh7yb3gskgy2syc";
  };

  propagatedBuildInputs = [ pycodestyle ];

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
