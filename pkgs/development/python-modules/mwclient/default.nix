{ stdenv, buildPythonPackage, fetchFromGitHub, requests, requests_oauthlib
, responses, mock, pytestcov, pytest, pytestcache, pytestpep8, coverage, six }:

buildPythonPackage rec {
  version = "0.9.3";
  pname = "mwclient";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mwclient";
    repo = "mwclient";
    rev = "v${version}";
    sha256 = "1kbrmq8zli2j93vmc2887bs7mqr4q1n908nbi1jjcci5v4cd4cqw";
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
