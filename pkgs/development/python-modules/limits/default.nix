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
  version = "2.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = pname;
    rev = version;
    hash = "sha256-ndENV9QBmOecyxFA9rikQ5+5la9k0OfRSTAOLg0aULU=";
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
