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
  lark,
  lxml,
  platformdirs,
  prompt-toolkit,
  pygments,
  python-doi,
  python-slugify,
  pyyaml,
  requests,

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
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "papis";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "papis";
    repo = "papis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZDGcuOCmddPaX6CldPf7YGHyIZfrG62ZQ6NXzFPDVAM=";
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
    lark
    lxml
    platformdirs
    prompt-toolkit
    pygments
    python-doi
    python-slugify
    pyyaml
    requests
  ]
  ++ lib.optionals withOptDeps finalAttrs.passthru.optional-dependencies.complete;

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
    writableTmpDirAsHomeHook
  ];

  enabledTestPaths = [
    "papis"
    "tests"
  ];

  disabledTests = [
    # Require network access
    "test_add_folder_name_cli"
    "test_add_link_cli"
    "test_download_document"
    "test_get_matching_importers_by_name"
    "test_matching_importers_by_uri"
    "test_yaml_unicode_dump"
  ]
  ++ lib.optionals withOptDeps [
    # Require network access
    "test_csl_style_download"
  ];

  meta = {
    description = "Powerful command-line document and bibliography manager";
    mainProgram = "papis";
    homepage = "https://papis.readthedocs.io/";
    changelog = "https://github.com/papis/papis/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nico202
      octvs
    ];
  };
})
