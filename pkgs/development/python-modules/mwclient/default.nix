{ stdenv, buildPythonPackage, fetchFromGitHub
, requests, requests_oauthlib, six
, pytest, pytestcache, pytestcov, responses, mock
}:

buildPythonPackage rec {
  version = "0.10.1";
  pname = "mwclient";

  src = fetchFromGitHub {
    owner = "mwclient";
    repo = "mwclient";
    rev = "v${version}";
    sha256 = "120snnsh9n5svfwkyj1w9jrxf99jnqm0jk282yypd3lpyca1l9hj";
  };

  checkInputs = [ pytest pytestcache pytestcov responses mock ];

  propagatedBuildInputs = [ requests requests_oauthlib six ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Python client library to the MediaWiki API";
    license = licenses.mit;
    homepage = "https://github.com/mwclient/mwclient";
  };
}
