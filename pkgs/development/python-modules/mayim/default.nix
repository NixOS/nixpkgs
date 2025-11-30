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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ahopkins";
    repo = "mayim";
    tag = "v${version}";
    hash = "sha256-mXGbPPO19H6fsWkvRzYyIVykHRryQo46WtH/XfqSIgY=";
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

  meta = with lib; {
    description = "Asynchronous SQL hydrator";
    homepage = "https://github.com/ahopkins/mayim";
    license = licenses.mit;
    maintainers = with maintainers; [ huyngo ];
  };
}
