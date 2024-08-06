{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  python,
  poetry-core,
  # install_requires
  charset-normalizer,
  h2,
  onecache,
  setuptools,
  # tests_require
  aiodns,
  aiohttp,
  asgiref,
  black,
  django,
  click,
  httpx,
  proxy-py,
  pytest,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-black,
  pytest-cov,
  pytest-django,
  pytest-mock,
  pytest-runner,
  pytest-sugar,
  pytest-timeout,
  uvicorn,
  httptools,
  mypy,
  mypy-extensions,
  pytest-mypy,
  typed-ast,
  uvloop,
  requests,
}:

buildPythonPackage rec {
  pname = "aiosonic";
  version = "0.20.1";
  pyproject = true;

  disabled = pythonOlder "3.8";
  dontCheckRuntimeDeps = true;

  src = fetchFromGitHub {
    owner = "sonic182";
    repo = "aiosonic";
    rev = "refs/tags/${version}";
    hash = "sha256-RMkmmXUqzt9Nsx8N+f9Xdbgjt1nd5NuJHs9dzarx8IY=";
  };

  build-system = [
    poetry-core
    pytest-runner
    setuptools
  ];

  meta = with lib; {
    changelog = "https://github.com/sonic182/aiosonic/blob/${version}/CHANGELOG.md";
    description = "A very fast Python asyncio http client";
    license = licenses.mit;
    homepage = "https://github.com/sonic182/aiosonic";
    maintainers = with maintainers; [ geraldog ];
  };
}
