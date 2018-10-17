{ stdenv, buildPythonPackage, fetchFromGitHub, requests, requests_oauthlib
, responses, mock, pytestcov, pytest, pytestcache, pytestpep8, coverage, six }:

buildPythonPackage rec {
  version = "0.9.1";
  pname = "mwclient";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mwclient";
    repo = "mwclient";
    rev = "v${version}";
    sha256 = "0l7l5j7znlyn2yqvdfxr4dq23wyp6d8z49pnkjqy2kan11nrjzym";
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
