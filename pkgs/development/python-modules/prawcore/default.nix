{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27
, requests
, testfixtures, mock, requests_toolbelt
, betamax, betamax-serializers, betamax-matchers, pytest
}:

buildPythonPackage rec {
  pname = "prawcore";
  version = "1.5.0";
  disabled = isPy27; # see https://github.com/praw-dev/prawcore/pull/101

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f1eafc8a65d671f9892354f73142014fbb5d3a9ee621568c662d0a354e0578b";
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
