{ stdenv, buildPythonPackage, fetchPypi, isPy27
, requests
, testfixtures, mock, requests_toolbelt
, betamax, betamax-serializers, betamax-matchers, pytest
}:

buildPythonPackage rec {
  pname = "prawcore";
  version = "1.4.0";
  disabled = isPy27; # see https://github.com/praw-dev/prawcore/pull/101

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf71388d869becbcbdfd90258b19d2173c197a457f2dd0bef0566b6cfb9b95a1";
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

  meta = with stdenv.lib; {
    description = "Low-level communication layer for PRAW";
    homepage = "https://praw.readthedocs.org/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
