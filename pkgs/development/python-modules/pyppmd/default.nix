{
  lib,
  atheris,
  black,
  buildPythonPackage,
  check-manifest,
  coverage,
  fetchFromGitea,
  flake8,
  hypothesis,
  isort,
  mypy,
  mypy-extensions,
  pygments,
  pytest,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  readme-renderer,
  setuptools,
  setuptools-scm,
  sphinx,
  sphinx-rtd-theme,
}:

buildPythonPackage rec {
  pname = "pyppmd";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "pyppmd";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZcGHrPvFhFG+NRy6YbYj74SkbUzjU8RM9606Mi/XQZQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies = {
    check = [
      black
      check-manifest
      flake8
      isort
      mypy
      mypy-extensions
      pygments
      readme-renderer
    ];

    docs = [
      sphinx
      sphinx-rtd-theme
    ];

    fuzzer = [
      atheris
      hypothesis
    ];

    test = [
      coverage
      hypothesis
      pytest
      pytest-benchmark
      pytest-cov-stub
      pytest-timeout
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "pyppmd" ];

  meta = {
    description = "Classes and functions for compressing and decompressing text data";
    homepage = "https://codeberg.org/miurahr/pyppmd";
    changelog = "https://codeberg.org/miurahr/pyppmd/releases/tag/v${version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
