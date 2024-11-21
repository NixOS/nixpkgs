{
  lib,
  buildPythonPackage,
  check-manifest,
  coverage,
  coveralls,
  fetchFromGitea,
  flake8,
  hypothesis,
  isort,
  mypy,
  mypy-extensions,
  pyannotate,
  pygments,
  pytest,
  pytest-cov-stub,
  pytestCheckHook,
  readme-renderer,
  setuptools,
  setuptools-scm,
  twine,
}:

buildPythonPackage rec {
  pname = "multivolumefile";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "multivolume";
    rev = "refs/tags/v${version}";
    hash = "sha256-7gjfF7biQZOcph2dfwi2ouDn/uIYik/KBQ0k6u5Ne+Q=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies = {
    check = [
      check-manifest
      flake8
      isort
      pygments
      readme-renderer
      twine
    ];

    test = [
      coverage
      coveralls
      hypothesis
      pyannotate
      pytest
      pytest-cov-stub
    ];

    type = [
      mypy
      mypy-extensions
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "multivolumefile" ];

  meta = {
    description = "Multi volume file wrapper";
    homepage = "https://codeberg.org/miurahr/multivolume";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
