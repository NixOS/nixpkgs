{ lib, buildPythonPackage, fetchPypi, isPy27
, requests
, testfixtures, mock, requests_toolbelt
, betamax, betamax-serializers, betamax-matchers, pytest
}:

buildPythonPackage rec {
  pname = "prawcore";
  version = "2.2.0";
  disabled = isPy27; # see https://github.com/praw-dev/prawcore/pull/101

  src = fetchPypi {
    inherit pname version;
    sha256 = "bde42fad459c4dcfe0f22a18921ef4981ee7cd286ea1de3eb697ba91838c9123";
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
