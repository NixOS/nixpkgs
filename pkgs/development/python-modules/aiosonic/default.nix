{
  pkgs,
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  # install_requires
  charset-normalizer,
  h2,
  onecache,
  pytest,
}:

buildPythonPackage rec {
  pname = "aiosonic";
  version = "0.20.1";
  pyproject = true;

  disabled = pythonOlder "3.8";
  doCheck = true;

  src = fetchFromGitHub {
    owner = "sonic182";
    repo = "aiosonic";
    rev = "refs/tags/${version}";
    hash = "sha256-RMkmmXUqzt9Nsx8N+f9Xdbgjt1nd5NuJHs9dzarx8IY=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    charset-normalizer
    onecache
    h2
  ];

  nativeCheckInputs = [
    pkgs.poetry
    pytest
    pkgs.nodejs
  ];

  checkPhase = ''
    export HOME="$(mktemp -d)"
    poetry install
    poetry run pytest --cov-append
  '';

  meta = with lib; {
    changelog = "https://github.com/sonic182/aiosonic/blob/${version}/CHANGELOG.md";
    description = "A very fast Python asyncio http client";
    license = licenses.mit;
    homepage = "https://github.com/sonic182/aiosonic";
    maintainers = with maintainers; [ geraldog ];
  };
}
