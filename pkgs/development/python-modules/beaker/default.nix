{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, mock
, webtest
, sqlalchemy
, pycrypto
, isPy27
, funcsigs
, pycryptopp
, redis
, memcached
, pylibmc
, pymongo
, cryptography
}:

buildPythonPackage rec {
  pname = "Beaker";
  version = "1.10.0";

  # The pypy release do not contains the tests
  src = fetchFromGitHub {
    owner = "bbangert";
    repo = "beaker";
    rev = "${version}";
    sha256 = "1xwbl8ggj0xlvih95m2b70cbrsazkzma7g6ivg724m6kh3xfwqhv";
  };

  checkInputs = [
    nose mock webtest redis memcached pylibmc pymongo cryptography
  ];

  postPatch = ''
    # fails on import because it tries to make a connection
    rm tests/test_memcached.py
  '';

  checkPhase = ''
    # ignore external tests
    NOSE_EXCLUDE=".*test_ext_.*" nosetests tests
  '';

  propagatedBuildInputs = [
    sqlalchemy
    pycrypto
  ] ++ lib.optionals (isPy27) [
    funcsigs
    pycryptopp
  ];

  meta = {
    description = "A Session and Caching library with WSGI Middleware";
    maintainers = with lib.maintainers; [ garbas domenkozar ];
  };
}
