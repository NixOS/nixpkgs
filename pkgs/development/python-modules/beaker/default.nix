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
}:

buildPythonPackage rec {
  pname = "Beaker";
  version = "1.8.0";

  # The pypy release do not contains the tests
  src = fetchFromGitHub {
    owner = "bbangert";
    repo = "beaker";
    rev = "${version}";
    sha256 = "17yfr7a307n8rdl09was4j60xqk2s0hk0hywdkigrpj4qnw0is7g";
  };

  buildInputs =
    [ nose
      mock
      webtest
    ];
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