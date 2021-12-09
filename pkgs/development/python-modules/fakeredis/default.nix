{ lib
, aioredis
, async_generator
, buildPythonPackage
, fetchFromGitHub
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

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
     owner = "jamesls";
     repo = "fakeredis";
     rev = "1.7.0";
     sha256 = "0vfyirrcmm31f1w4apa9kwndbg3nf5fqkzpqjqhhplcqsj1x98rz";
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
