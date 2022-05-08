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
  version = "1.7.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aWl//usJk5BzYF7qyX9SS8yrrgQmV1eldcf8kjCHqmU=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "redis<4.2.0" "redis"
  '';

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
