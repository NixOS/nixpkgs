{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  arxiv,
  beautifulsoup4,
  bibtexparser,
  click,
  colorama,
  dominate,
  filetype,
  habanero,
  isbnlib,
  lxml,
  platformdirs,
  prompt-toolkit,
  pygments,
  pyparsing,
  python-doi,
  python-slugify,
  pyyaml,
  requests,
  stevedore,

  # optional dependencies
  chardet,
  citeproc-py,
  jinja2,
  markdownify,
  whoosh,

  # switch for optional dependencies
  withOptDeps ? false,

  # tests
  docutils,
  git,
  pytestCheckHook,
  pytest-cov-stub,
  sphinx,
  sphinx-click,
}:
buildPythonPackage rec {
  pname = "papis";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "papis";
    repo = "papis";
    tag = "v${version}";
    hash = "sha256-V4YswLNYwfBYe/Td0PEeDG++ClZoF08yxXjUXuyppPI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    arxiv
    beautifulsoup4
    bibtexparser
    click
    colorama
    dominate
    filetype
    habanero
    isbnlib
    lxml
    platformdirs
    prompt-toolkit
    pygments
    pyparsing
    python-doi
    python-slugify
    pyyaml
    requests
    stevedore
  ]
  ++ lib.optionals withOptDeps optional-dependencies.complete;

  optional-dependencies = {
    complete = [
      chardet
      citeproc-py
      jinja2
      markdownify
      whoosh
    ];
  };

  pythonImportsCheck = [ "papis" ];

  nativeCheckInputs = [
    docutils
    git
    pytestCheckHook
    pytest-cov-stub
    sphinx
    sphinx-click
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  enabledTestPaths = [
    "papis"
    "tests"
  ];

  disabledTestPaths = [
    # Require network access
    "tests/downloaders"
    "papis/downloaders/usenix.py"
  ];

  disabledTests = [
    # Require network access
    "test_yaml_unicode_dump"
  ];

  meta = {
    description = "Powerful command-line document and bibliography manager";
    mainProgram = "papis";
    homepage = "https://papis.readthedocs.io/";
    changelog = "https://github.com/papis/papis/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nico202
      teto
    ];
  };
}
