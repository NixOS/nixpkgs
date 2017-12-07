{ stdenv, buildPythonPackage, fetchFromGitHub
, requests, decorator, flake8, mock, six, update_checker, pytestrunner, prawcore
, pytest, betamax, betamax-serializers, betamax-matchers, requests_toolbelt
}:

buildPythonPackage rec {
  pname = "praw";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "praw";
    rev = "v${version}";
    sha256 = "0nwfadczxa1fyq65zc3sfv8g2r4w3xrx3bdi5fv9xpn97wh2ifgw";
  };

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
