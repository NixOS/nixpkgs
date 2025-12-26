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
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ahopkins";
    repo = "mayim";
    tag = "v${version}";
    hash = "sha256-RJMPqqmvpwvdRTaVznxGunvC0/KlL0z1GUX1VBTCbwo=";
  };

  build-system = [
    setuptools
    wheel
  ];

  optional-dependencies = {
    postgres = [ psycopg ] ++ psycopg.optional-dependencies.pool;
    mysql = [ asyncmy ];
    sqlite = [ aiosqlite ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ]
  ++ (with optional-dependencies; [
    postgres
    mysql
    sqlite
  ]);

  pythonImportsCheck = [ "mayim" ];

  meta = {
    description = "Asynchronous SQL hydrator";
    homepage = "https://github.com/ahopkins/mayim";
    changelog = "https://github.com/ahopkins/mayim/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ huyngo ];
  };
}
