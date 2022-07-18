{ lib
, buildPythonApplication
, fetchFromGitHub
, dill
, coverage
, coveralls
, mock
, nose
}:

buildPythonApplication rec {
  pname = "expiringdict";
  version = "1.2.2";

  # use fetchFromGitHub instead of fetchPypi because the test suite of
  # the package is not included into the PyPI tarball
  src = fetchFromGitHub {
    owner = "mailgun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vRhJSHIqc51I+s/wndtfANM44CKW3QS1iajqyoSBf0I=";
  };

  checkInputs = [
    dill
    coverage
    coveralls
    mock
    nose
  ];

  checkPhase = ''
    nosetests -v --with-coverage --cover-package=expiringdict
  '';

  pythonImportsCheck = [ "expiringdict" ];

  meta = with lib; {
    description = "Dictionary with auto-expiring values for caching purposes";
    homepage = "https://pypi.org/project/expiringdict/";
    license = licenses.asl20;
    maintainers = with maintainers; [ gravndal ];
  };
}
