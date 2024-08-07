{
  pkgs,
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pytest,
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

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pkgs.poetry
    pytest
  ];

  checkPhase = ''
    export HOME="$(mktemp -d)"
    poetry install
    poetry run pytest --cov-append
  '';

  meta = with lib; {
    changelog = "https://github.com/sonic182/onecache/blob/${version}/CHANGELOG.md";
    description = "Python LRU and TTL cache for sync and async code";
    license = licenses.mit;
    homepage = "https://github.com/sonic182/onecache";
    maintainers = with maintainers; [ geraldog ];
  };
}
