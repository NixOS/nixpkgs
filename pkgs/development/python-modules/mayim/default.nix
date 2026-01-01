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
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ahopkins";
    repo = "mayim";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-RJMPqqmvpwvdRTaVznxGunvC0/KlL0z1GUX1VBTCbwo=";
=======
    hash = "sha256-mXGbPPO19H6fsWkvRzYyIVykHRryQo46WtH/XfqSIgY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Asynchronous SQL hydrator";
    homepage = "https://github.com/ahopkins/mayim";
    changelog = "https://github.com/ahopkins/mayim/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ huyngo ];
=======
  meta = with lib; {
    description = "Asynchronous SQL hydrator";
    homepage = "https://github.com/ahopkins/mayim";
    license = licenses.mit;
    maintainers = with maintainers; [ huyngo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
