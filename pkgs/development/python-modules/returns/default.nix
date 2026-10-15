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
  version = "0.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dry-python";
    repo = "returns";
    tag = version;
    hash = "sha256-xCdCZtbo1AmBeKdY4CeQdK8s+23EfTyQa5o78j1+yVw=";
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
