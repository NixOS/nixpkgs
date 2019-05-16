{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, gevent
, certifi
, six
, backports_ssl_match_hostname
}:

buildPythonPackage rec {
  pname = "geventhttpclient";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd87af8854f5fb05738916c8973671f7035568aec69b7c842887d6faf9c0a01d";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ gevent certifi six backports_ssl_match_hostname ];

  # Several tests fail that require network
  doCheck = false;
  checkPhase = ''
    py.test $out
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/gwik/geventhttpclient;
    description = "HTTP client library for gevent";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };

}
