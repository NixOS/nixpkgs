{ lib, fetchPypi, buildPythonPackage, pycodestyle, glibcLocales
, toml
}:

buildPythonPackage rec {
  pname = "autopep8";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44f0932855039d2c15c4510d6df665e4730f2b8582704fa48f9c55bd3e17d979";
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
