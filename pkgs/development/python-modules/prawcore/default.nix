{ stdenv, buildPythonPackage, fetchPypi
, requests
, testfixtures, mock, requests_toolbelt
, betamax, betamax-serializers, betamax-matchers
}:

buildPythonPackage rec {
  pname = "prawcore";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab5558efb438aa73fc66c4178bfc809194dea3ce2addf4dec873de7e2fd2824e";
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
  ];

  meta = with stdenv.lib; {
    description = "Low-level communication layer for PRAW";
    homepage = https://praw.readthedocs.org/;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
