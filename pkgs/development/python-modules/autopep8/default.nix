{ lib
, fetchPypi
, buildPythonPackage
, pycodestyle
, glibcLocales
, tomli
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "autopep8";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ixZZx/AD5pMZn1LK/9wGWFuwcWkAu8anRC/ZMdZYwHc=";
  };

  propagatedBuildInputs = [ pycodestyle tomli ];

  checkInputs = [
    glibcLocales
    pytestCheckHook
  ];

  disabledTests = [
    # missing tox.ini file from pypi package
    "test_e101_skip_innocuous"
  ];

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = "https://pypi.org/project/autopep8/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
