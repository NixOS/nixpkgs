{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  exceptiongroup,
  pytest-asyncio,
  pytest-cov,
  pytest-repeat,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dishka";
  version = "1.10.1";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "reagento";
    repo = "dishka";
    tag = finalAttrs.version;
    hash = "sha256-HW0n4XgiCNzWaiql6ZKJ5ido/7wGWTYwpd38+EjYXsA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools==80.9.0"' '"setuptools"' \
      --replace-fail '"setuptools-scm[simple]==9.2.0"' '"setuptools-scm[simple]"'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = lib.optionals (pythonOlder "3.11") [ exceptiongroup ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov
    pytest-repeat
    pytestCheckHook
  ];

  # Other tests/integrations/* need extra frameworks like fastapi and celery
  enabledTestPaths = [
    "tests/integrations/base"
    "tests/unit"
  ];

  pythonImportsCheck = [ "dishka" ];

  meta = {
    description = "Cute DI framework with scopes and agreeable API";
    homepage = "https://dishka.readthedocs.io/en/stable/";
    changelog = "https://github.com/reagento/dishka/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaravrav ];
  };
})
