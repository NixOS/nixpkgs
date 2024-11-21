{
  lib,
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
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  readme-renderer,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "pybcj";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "pybcj";
    rev = "refs/tags/v${version}";
    hash = "sha256-2hNkOEnNmzyzzSMr2qxIcFxMjcNndwTLLgVGBnKhNtQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
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

    test = [
      coverage
      hypothesis
      pytest
      pytest-cov-stub
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "bcj" ];

  meta = {
    description = "BCJ(Branch-Call-Jump) filter for python";
    homepage = "https://codeberg.org/miurahr/pybcj";
    changelog = "https://codeberg.org/miurahr/pybcj/releases/tag/v${version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
