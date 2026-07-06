{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "nest-asyncio";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erdewit";
    repo = "nest_asyncio";
    tag = "v${version}";
    hash = "sha256-5I5WItOl1QpyI4OXZgZf8GiQ7Jlo+SJbDicIbernaU4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.14") [
    "tests/nest_test.py::NestTest::test_timeout"
  ];

  pythonImportsCheck = [ "nest_asyncio" ];

  meta = {
    description = "Patch asyncio to allow nested event loops";
    homepage = "https://github.com/erdewit/nest_asyncio";
    changelog = "https://github.com/erdewit/nest_asyncio/releases/tag/v${version}";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
  };
}
