{
  lib,
  buildPythonPackage,
  check-manifest,
  docutils,
  fetchFromGitea,
  flake8,
  isort,
  mypy,
  mypy-extensions,
  pyannotate,
  pygments,
  pytest,
  pytestCheckHook,
  pythonOlder,
  readme-renderer,
  setuptools,
  setuptools-scm,
  sphinx,
  twine,
}:

buildPythonPackage rec {
  pname = "inflate64";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "inflate64";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ytz+QbztpNm7cbUqWu0rlYzk3Q3qyg0evikCV22+mXo=";
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
      mypy
      mypy-extensions
      pygments
      readme-renderer
      twine
    ];

    docs = [
      docutils
      sphinx
    ];

    test = [
      pyannotate
      pytest
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "inflate64" ];

  meta = {
    description = "Python package to provide compression and decompression feature with Enhanced Deflate algorithm";
    homepage = "https://codeberg.org/miurahr/inflate64";
    changelog = "https://codeberg.org/miurahr/inflate64/releases/tag/v${version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
