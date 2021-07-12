{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, glibcLocales
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
, funcsigs ? null
, pycryptopp ? null
}:

buildPythonPackage rec {
  pname = "Beaker";
  version = "1.11.0";

  # The pypy release do not contains the tests
  src = fetchFromGitHub {
    owner = "bbangert";
    repo = "beaker";
    rev = version;
    sha256 = "059sc7iar90lc2y9mppdis5ddfcxyirz03gmsfb0307f5dsa1dhj";
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
    glibcLocales
    memcached
    mock
    nose
    pylibmc
    pymongo
    redis
    webtest
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
      ${lib.optionalString (!stdenv.isLinux) ''-e "test_cookie_expires_different_locale"''} \
      -vv tests
  '';

  meta = {
    description = "A Session and Caching library with WSGI Middleware";
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
