{ lib
, aioredis
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, lupa
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pytest-mock
, pythonOlder
, redis
, six
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "2.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dsoftwareinc";
    repo = "fakeredis-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-W24DMVp3E6SYaVTUYCRDm/tLaGcjDqecO3rN1RO/J84=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    redis
    six
    sortedcontainers
  ];

  checkInputs = [
    hypothesis
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
    lua = [
      lupa
    ];
    aioredis = [
      aioredis
    ];
  };

  pythonImportsCheck = [
    "fakeredis"
  ];

  meta = with lib; {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/dsoftwareinc/fakeredis-py";
    changelog = "https://github.com/cunla/fakeredis-py/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
