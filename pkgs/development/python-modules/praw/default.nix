{ stdenv, buildPythonPackage, fetchFromGitHub
, requests, decorator, flake8, mock, six, update_checker, pytestrunner, prawcore
, pytest, betamax, betamax-serializers, betamax-matchers, requests_toolbelt
}:

buildPythonPackage rec {
  pname = "praw";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "praw";
    rev = "v${version}";
    sha256 = "13vbh2r952ai2m6sc79psfwaj5fc8cssdg2pqpizg2mwd0l1s6lb";
  };

  postPatch = ''
    # drop upper bound of prawcore requirement
    sed -ri "s/'(prawcore >=.+), <.+'/'\1'/" setup.py
  '';

  propagatedBuildInputs = [
    requests
    decorator
    flake8
    mock
    six
    update_checker
    pytestrunner
    prawcore
  ];

  checkInputs = [
    pytest
    betamax
    betamax-serializers
    betamax-matchers
    requests_toolbelt
  ];

  meta = with stdenv.lib; {
    description = "Python Reddit API wrapper";
    homepage = http://praw.readthedocs.org/;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jgeerds ];
  };
}
