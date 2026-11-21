{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  hypothesis,
  mypy,
  poetry-core,
  pytest-aio,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-mypy,
  pytest-mypy-plugins,
  pytestCheckHook,
  setuptools,
  trio,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "returns";
  version = "0.30.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dry-python";
    repo = "returns";
    tag = version;
    hash = "sha256-lU2h1QcbK4sIbjvM64s4MLcOk3B4I+CF91+IJGCGwQM=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [
    anyio
    httpx
    hypothesis
    mypy
    pytestCheckHook
    pytest-aio
    pytest-benchmark
    pytest-cov-stub
    pytest-mypy
    pytest-mypy-plugins
    setuptools
    trio
  ];

  pythonImportsCheck = [ "returns" ];

  disabledTestPaths = [ "typesafety" ];

  meta = {
    description = "Make your functions return something meaningful, typed, and safe";
    homepage = "https://github.com/dry-python/returns";
    changelog = "https://github.com/dry-python/returns/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jessemoore ];
  };
}
