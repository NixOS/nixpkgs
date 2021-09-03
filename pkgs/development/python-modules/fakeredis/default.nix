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
    sha256 = "sha256-Ecz8l2nXGNN+RbOC5kproCWGtiKvoDcaa9hXZtciVfM=";
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
    # Missing support for later pytest-asyncio, https://github.com/jamesls/fakeredis/issues/307
    "test/test_aioredis1.py"
  ];

  pythonImportsCheck = [ "fakeredis" ];

  meta = with lib; {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/jamesls/fakeredis";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
