{ lib
, buildPythonPackage
, deprecated
, fetchFromGitHub
, hiro
, packaging
, pymemcache
, pymongo
, pytest-asyncio
, pytest-lazy-fixture
, pytestCheckHook
, pythonOlder
, redis
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "limits";
  version = "2.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = pname;
    rev = version;
    hash = "sha256-4Njai0LT72U9Ra4pgHU0ZjF9oZexbijUgLFYaZi/LgE=";
  };

  propagatedBuildInputs = [
    deprecated
    packaging
    setuptools
    typing-extensions
  ];

  checkInputs = [
    hiro
    pymemcache
    pymongo
    pytest-asyncio
    pytest-lazy-fixture
    pytestCheckHook
    redis
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=limits" "" \
      --replace "-K" ""
    # redis-py-cluster doesn't support redis > 4
    substituteInPlace tests/conftest.py \
      --replace "import rediscluster" ""
  '';

  pythonImportsCheck = [
    "limits"
  ];

  pytestFlagsArray = [
    # All other tests require a running Docker instance
    "tests/test_limits.py"
    "tests/test_ratelimit_parser.py"
    "tests/test_limit_granularities.py"
  ];

  meta = with lib; {
    description = "Rate limiting utilities";
    homepage = "https://limits.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
