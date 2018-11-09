{ stdenv, buildPythonPackage, fetchFromGitHub, requests, requests_oauthlib
, responses, mock, pytestcov, pytest, pytestcache, pytestpep8, coverage, six }:

buildPythonPackage rec {
  version = "0.9.2";
  pname = "mwclient";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mwclient";
    repo = "mwclient";
    rev = "v${version}";
    sha256 = "0553pa5gm74k0lsrbcw5ic8jypnh5c3p58i50kzjvgcqz4frsafi";
  };

  buildInputs = [ mock responses pytestcov pytest pytestcache pytestpep8 coverage ];

  propagatedBuildInputs = [ six requests requests_oauthlib ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Python client library to the MediaWiki API";
    license = licenses.mit;
    homepage = https://github.com/mwclient/mwclient;
  };
}
