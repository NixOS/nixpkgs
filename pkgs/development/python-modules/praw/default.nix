{ stdenv, buildPythonPackage, fetchFromGitHub
, requests, decorator, flake8, mock, six, update_checker, pytestrunner, prawcore
, pytest_3, betamax, betamax-serializers, betamax-matchers, requests_toolbelt
}:

buildPythonPackage rec {
  pname = "praw";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "praw";
    rev = "v${version}";
    sha256 = "0y6nyz8vf98gl1qfmnznv3dbvlbzdl6mz99vk673nyfn3hbs451i";
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
    pytest_3
    betamax
    betamax-serializers
    betamax-matchers
    requests_toolbelt
  ];

  meta = with stdenv.lib; {
    description = "Python Reddit API wrapper";
    homepage = https://praw.readthedocs.org/;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
