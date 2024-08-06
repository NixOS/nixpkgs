{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  python,
  poetry-core,
  # install_requires
  autopep8,
  sphinx,
  pylint,
  # tests_require
  flake8,
  flake8-docstrings,
  pytest,
  pytest-asyncio,
  pytest-sugar,
  pytest-cov
}:

buildPythonPackage rec {
  pname = "onecache";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sonic182";
    repo = "onecache";
    rev = "refs/tags/${version}";
    hash = "sha256-go/3HntSLzzTmHS9CxGPHT6mwXl+6LuWFmkGygGIjqU=";
  };

  build-system = [
    poetry-core
  ];

  meta = with lib; {
    changelog = "https://github.com/sonic182/onecache/blob/${version}/CHANGELOG.md";
    description = "Python LRU and TTL cache for sync and async code";
    license = licenses.mit;
    homepage = "https://github.com/sonic182/onecache";
    maintainers = with maintainers; [ geraldog ];
  };
}
