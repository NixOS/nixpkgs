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
  pytest-mypy,
  pytest-mypy-plugins,
  pytest-subtests,
  pytestCheckHook,
  setuptools,
  trio,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "returns";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dry-python";
    repo = "returns";
    tag = version;
    hash = "sha256-VQzsa/uNTQVND0kc20d25to/6LELEiS3cqvG7a1kDw4=";
  };

  postPatch = ''
    sed -i setup.cfg \
      -e '/--cov.*/d'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [
    anyio
    httpx
    # https://github.com/dry-python/returns/issues/2224
    (hypothesis.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "HypothesisWorks";
        repo = "hypothesis";
        tag = "hypothesis-python-6.136.9";
        hash = "sha256-Q1wxIJwAYKZ0x6c85CJSGgcdKw9a3xFw8YpJROElSNU=";
      };
    }))
    mypy
    pytestCheckHook
    pytest-aio
    pytest-mypy
    pytest-mypy-plugins
    pytest-subtests
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
