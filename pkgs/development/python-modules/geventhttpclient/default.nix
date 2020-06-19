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
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "967b11c4a37032f98c08f58176e4ac8de10473ab0c1f617acb8202d44b97fe21";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ gevent certifi six backports_ssl_match_hostname ];

  # Several tests fail that require network
  doCheck = false;
  checkPhase = ''
    py.test $out
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/gwik/geventhttpclient";
    description = "HTTP client library for gevent";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };

}
