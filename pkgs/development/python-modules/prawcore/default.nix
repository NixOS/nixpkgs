{ stdenv, buildPythonPackage, fetchFromGitHub
, requests
, testfixtures, mock, requests_toolbelt
, betamax, betamax-serializers, betamax-matchers
}:

buildPythonPackage rec {
  pname = "prawcore";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "prawcore";
    rev = "v${version}";
    sha256 = "1z5fz6v4bv6xw84l4q3rpw3j63bb2dldl0fd6ckz8wqlpb2l45br";
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
    homepage = http://praw.readthedocs.org/;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jgeerds ];
  };
}
