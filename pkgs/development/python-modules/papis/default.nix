{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

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

  patches = [
    (fetchpatch2 {
      name = "fix-support-new-click-in-papisrunner.patch";
      url = "https://github.com/papis/papis/commit/0e3ffff4bd1b62cdf0a9fdc7f54d6a2e2ab90082.patch?full_index=1";
      hash = "sha256-KUw5U5izTTWqXHzGWLibtqHWAsVxla6SA8x6SJ07/zU=";
    })
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
