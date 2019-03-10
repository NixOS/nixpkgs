{ stdenv, buildPythonPackage, fetchFromGitHub
, requests, requests_oauthlib, six
, pytest, pytestpep8, pytestcache, pytestcov, responses, mock
}:

buildPythonPackage rec {
  version = "0.9.3";
  pname = "mwclient";

  src = fetchFromGitHub {
    owner = "mwclient";
    repo = "mwclient";
    rev = "v${version}";
    sha256 = "1kbrmq8zli2j93vmc2887bs7mqr4q1n908nbi1jjcci5v4cd4cqw";
  };

  checkInputs = [ pytest pytestpep8 pytestcache pytestcov responses mock ];

  propagatedBuildInputs = [ requests requests_oauthlib six ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Python client library to the MediaWiki API";
    license = licenses.mit;
    homepage = https://github.com/mwclient/mwclient;
  };
}
