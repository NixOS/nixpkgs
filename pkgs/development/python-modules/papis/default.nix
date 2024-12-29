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

  # tests
  docutils,
  git,
  pytestCheckHook,
  sphinx,
  sphinx-click,
}:
buildPythonPackage rec {
  pname = "papis";
  version = "0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "papis";
    repo = "papis";
    rev = "refs/tags/v${version}";
    hash = "sha256-UpZoMYk4URN8tSFGIynVzWMk+9S0izROAgbx6uI2cN8=";
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
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=papis" ""
  '';

  pythonImportsCheck = [ "papis" ];

  nativeCheckInputs = [
    docutils
    git
    pytestCheckHook
    sphinx
    sphinx-click
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [
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
    changelog = "https://github.com/papis/papis/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nico202
      teto
    ];
  };
}
