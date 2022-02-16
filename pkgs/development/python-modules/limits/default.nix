{ lib
, buildPythonPackage
, fetchFromGitHub
, hiro
, pymemcache
, pymongo
, pytest-asyncio
, pytest-lazy-fixture
, pytestCheckHook
, pythonOlder
, redis
, setuptools
}:

buildPythonPackage rec {
  pname = "limits";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = pname;
    rev = version;
    hash = "sha256-KSYcIdLQ6TZpimxXyV88/V35GbBJ/9k9+UBM2KTMRR4=";
  };

  propagatedBuildInputs = [
    setuptools
    redis
    pymemcache
    pymongo
  ];

  checkInputs = [
    hiro
    pytest-asyncio
    pytest-lazy-fixture
    pytestCheckHook
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
