{ lib
, buildPythonPackage
, fetchPypi
, pytest
, gevent
, certifi
, six
, backports_ssl_match_hostname
, pythonOlder
}:

buildPythonPackage rec {
  pname = "geventhttpclient";
  version = "1.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f0ab18d84ef26ba0c9df73ae2a41ba30a46072b447f2e36c740400de4a63d44";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ gevent certifi six ]
    ++ lib.optionals (pythonOlder "3.7") [ backports_ssl_match_hostname ];

  # Several tests fail that require network
  doCheck = false;
  checkPhase = ''
    py.test $out
  '';

  meta = with lib; {
    homepage = "https://github.com/gwik/geventhttpclient";
    description = "HTTP client library for gevent";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };

}
