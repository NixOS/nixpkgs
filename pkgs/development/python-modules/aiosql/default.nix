{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pg8000,
  psycopg,
  pytest-asyncio,
  pytest-postgresql,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  sphinx-rtd-theme,
  sphinxHook,
}:

buildPythonPackage rec {
  pname = "aiosql";
  version = "15.0";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "nackjicholson";
    repo = "aiosql";
    tag = version;
    hash = "sha256-zKKp37tM0pBnWJuLmQhoQpWnUinLG/Nmnpv1rdM8wYM=";
  };

  sphinxRoot = "docs/source";

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    sphinx-rtd-theme
    sphinxHook
  ];

  nativeCheckInputs = [
    pg8000
    psycopg
    pytest-asyncio
    pytest-postgresql
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiosql" ];

  meta = {
    description = "Simple SQL in Python";
    homepage = "https://nackjicholson.github.io/aiosql/";
    changelog = "https://github.com/nackjicholson/aiosql/releases/tag/${src.tag}";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ kaction ];
  };
}
