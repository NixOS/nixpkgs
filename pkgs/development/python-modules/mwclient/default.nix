{ stdenv, buildPythonPackage, fetchFromGitHub
, requests, requests_oauthlib, six
, pytest, pytestpep8, pytestcache, pytestcov, responses, mock
}:

buildPythonPackage rec {
  version = "0.10.0";
  pname = "mwclient";

  src = fetchFromGitHub {
    owner = "mwclient";
    repo = "mwclient";
    rev = "v${version}";
    sha256 = "1c3q6lwmb05yqywc4ya98ca7hsl15niili8rccl4n1yqp77c103v";
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
