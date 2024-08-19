{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,

  psycopg,
  aiosqlite,
  asyncmy,

  # test
  pytest-asyncio,
  pytest-cov-stub,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mayim";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ahopkins";
    repo = "mayim";
    rev = "refs/tags/v${version}";
    hash = "sha256-nb0E9kMEJUihaCp8RnqGh0nSyDQo50eL1C4K5lBPlPQ=";
  };

  build-system = [
    setuptools
    wheel
  ];

  passthru.optional-dependencies = {
    postgres = [ psycopg ] ++ psycopg.optional-dependencies.pool;
    mysql = [ asyncmy ];
    sqlite = [ aiosqlite ];
  };

  nativeCheckInputs =
    [
      pytestCheckHook
      pytest-asyncio
      pytest-cov-stub
    ]
    ++ (with passthru.optional-dependencies; [
      postgres
      mysql
      sqlite
    ]);

  pythonImportsCheck = [ "mayim" ];

  meta = with lib; {
    description = "Asynchronous SQL hydrator";
    homepage = "https://github.com/ahopkins/mayim";
    license = licenses.mit;
    maintainers = with maintainers; [ huyngo ];
  };
}
