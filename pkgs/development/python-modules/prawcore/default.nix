{ stdenv, buildPythonPackage, fetchFromGitHub
, requests
, testfixtures, mock, requests_toolbelt
, betamax, betamax-serializers, betamax-matchers
}:

buildPythonPackage rec {
  pname = "prawcore";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "prawcore";
    rev = "v${version}";
    sha256 = "0v16n6bzf483i00bn0qykrg3wvw9dbnfdl512pw8n635ld1g7cb8";
  };

  postPatch = ''
    sed -i "s/'testfixtures >4.13.2, <6'/'testfixtures >4.13.2'/g" setup.py
  '';

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
    homepage = http://praw.readthedocs.org/;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jgeerds ];
  };
}
