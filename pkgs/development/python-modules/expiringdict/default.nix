{ lib
, buildPythonPackage
, fetchFromGitHub
, dill
, coverage
, coveralls
, mock
, nose
}:

buildPythonPackage rec {
  pname = "expiringdict";
  version = "1.2.2";
  format = "setuptools";

  # use fetchFromGitHub instead of fetchPypi because the test suite of
  # the package is not included into the PyPI tarball
  src = fetchFromGitHub {
    owner = "mailgun";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vRhJSHIqc51I+s/wndtfANM44CKW3QS1iajqyoSBf0I=";
  };

  nativeCheckInputs = [
    dill
    coverage
    coveralls
    mock
    nose
  ];

  checkPhase = ''
    runHook preCheck
    nosetests -v --with-coverage --cover-package=expiringdict
    runHook postCheck
  '';

  pythonImportsCheck = [
    "expiringdict"
  ];

  meta = with lib; {
    description = "Dictionary with auto-expiring values for caching purposes";
    homepage = "https://github.com/mailgun/expiringdict";
    license = licenses.asl20;
    maintainers = with maintainers; [ gravndal ];
  };
}
