{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pylibmc
, memcached
, redis
, pymongo
, mock
, webtest
, sqlalchemy
, pycrypto
, cryptography
, isPy27
, isPy3k
, funcsigs
, pycryptopp
}:

buildPythonPackage rec {
  pname = "Beaker";
  version = "1.10.1";

  # The pypy release do not contains the tests
  src = fetchFromGitHub {
    owner = "bbangert";
    repo = "beaker";
    rev = version;
    sha256 = "0xrvg503xmi28w0hllr4s7fkap0p09fgw2wax3p1s2r6b3xjvbz7";
  };

  propagatedBuildInputs = [
    sqlalchemy
    pycrypto
    cryptography
  ] ++ lib.optionals (isPy27) [
    funcsigs
    pycryptopp
  ];

  checkInputs = [
    nose
    mock
    webtest
    pylibmc
    memcached
    redis
    pymongo
  ];


  # Can not run memcached tests because it immediately tries to connect
  postPatch = lib.optionalString isPy3k ''
    substituteInPlace setup.py \
      --replace "python-memcached" "python3-memcached"
    '' + ''

    rm tests/test_memcached.py
  '';

  # Disable external tests because they need to connect to a live database.
  # Also disable a test in test_cache.py called "test_upgrade" because
  # it currently fails on darwin.
  # Please see issue https://github.com/bbangert/beaker/issues/166
  checkPhase = ''
    nosetests \
      -e ".*test_ext_.*" \
      -e "test_upgrade" \
      -vv tests
  '';

  meta = {
    description = "A Session and Caching library with WSGI Middleware";
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
