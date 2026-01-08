{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  hypothesis_6_136,
  mypy,
  poetry-core,
  pytest-aio,
  pytest-mypy,
  pytest-mypy-plugins,
  pytest-subtests,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  trio,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "returns";
  version = "0.26.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

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
    hypothesis_6_136
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
