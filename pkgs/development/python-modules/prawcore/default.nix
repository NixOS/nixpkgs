{ stdenv, buildPythonPackage, fetchFromGitHub
, requests
, testfixtures, mock, requests_toolbelt
, betamax, betamax-serializers, betamax-matchers
}:

buildPythonPackage rec {
  pname = "prawcore";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "prawcore";
    rev = "v${version}";
    sha256 = "1j905wi5n2xgik3yk2hrv8dky318ahfjl5k1zs21mrl81jk0907f";
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
