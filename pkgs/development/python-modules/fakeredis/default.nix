{ lib
, aioredis
, async_generator
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, hypothesis
, lupa
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, redis
, six
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jamesls";
    repo = pname;
    rev = version;
    hash = "sha256-P6PUg9SY0Qshlvj+iV1xdrzVLJ9JXUV4cGHUynKO3m0=";
  };

  propagatedBuildInputs = [
    aioredis
    lupa
    redis
    six
    sortedcontainers
  ];

  checkInputs = [
    async_generator
    hypothesis
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  patches = [
    # Support for redis <= 4.1.0, https://github.com/jamesls/fakeredis/pull/324
    (fetchpatch {
      name = "support-redis-4.1.0.patch";
      url = "https://github.com/jamesls/fakeredis/commit/8ef8dc6dacc9baf571d66a25ffbf0fadd7c70f78.patch";
      sha256 = "sha256-4DrF/5WEWQWlJZtAi4qobMDyRAAcO/weHIaK9waN00k=";
    })
  ];

  disabledTestPaths = [
    # AttributeError: 'AsyncGenerator' object has no attribute XXXX
    "test/test_aioredis2.py"
  ];

  pythonImportsCheck = [
    "fakeredis"
  ];

  meta = with lib; {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/jamesls/fakeredis";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
