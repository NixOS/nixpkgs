{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel

, psycopg
, aiosqlite
, asyncmy

# test
, pytest-asyncio

, pytestCheckHook
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

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=src --cov-append --cov-report term-missing" ""
  '';

  passthru.optional-dependencies = {
    postgres = [
      psycopg
    ] ++ psycopg.optional-dependencies.pool;
    mysql = [
      asyncmy
    ];
    sqlite = [
      aiosqlite
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ] ++ (with passthru.optional-dependencies; [postgres mysql sqlite]);

  pythonImportsCheck = [
    "mayim"
  ];

  meta = with lib; {
    description = "Asynchronous SQL hydrator";
    homepage = "https://github.com/ahopkins/mayim";
    license = licenses.mit;
    maintainers = with maintainers; [ huyngo ];
  };
}
