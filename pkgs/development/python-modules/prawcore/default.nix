{ lib, buildPythonPackage, fetchPypi, isPy27
, requests
, testfixtures, mock, requests_toolbelt
, betamax, betamax-serializers, betamax-matchers, pytest
}:

buildPythonPackage rec {
  pname = "prawcore";
  version = "2.0.0";
  disabled = isPy27; # see https://github.com/praw-dev/prawcore/pull/101

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tJjZtvVJkQBecn1SNcj0nqW6DJpteT+3Q7QPoInNNtE=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    testfixtures
    mock
    betamax
    betamax-serializers
    betamax-matchers
    requests_toolbelt
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Low-level communication layer for PRAW";
    homepage = "https://praw.readthedocs.org/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
