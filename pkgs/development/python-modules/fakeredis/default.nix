{ lib
, aioredis
, async_generator
, buildPythonPackage
, fetchPypi
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
  version = "1.6.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11ccfc9769d718d37e45b382e64a6ba02586b622afa0371a6bd85766d72255f3";
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

  pythonImportsCheck = [ "fakeredis" ];

  meta = with lib; {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/jamesls/fakeredis";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
