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
  lxml,
  platformdirs,
  prompt-toolkit,
  pygments,
  pyparsing,
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
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "papis";
    repo = "papis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G+ryUMBUEbGxUG+u2YwZbT04IAzOmajtIPXP12MaXsY=";
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
    lxml
    platformdirs
    prompt-toolkit
    pygments
    pyparsing
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

  # Until a release >0.15.0 (that would already contain these commits)
  patches = [
    # Commit 44c6463: chore: move isbnlib to optional dependencies
    (fetchpatch2 {
      url = "https://github.com/papis/papis/commit/44c6463f79cbc3a09adb541ae7df4e00a194b86b.patch?full_index=1";
      hash = "sha256-3E18cyzkiZsNvgH/X8dZu+3tGGpbBsaQ3nIoDuIYFqw=";
    })
    # Commit 7518e53: chore: remove isbn dependency
    (fetchpatch2 {
      url = "https://github.com/papis/papis/commit/7518e53e5d485e3cec1e202af6cb4921b9976b5b.patch?full_index=1";
      hash = "sha256-iBqlvHfH+6fyhi2C7lpwI1O59DKrKp7p45x29kzPRR0=";
    })
    # Commit 15cae59: test: skip tests if missing isbnlib
    (fetchpatch2 {
      url = "https://github.com/papis/papis/commit/15cae5986ae9dec75c7d103757adbd73c39feb89.patch?full_index=1";
      hash = "sha256-kuVZdOd+H99TinM7yAs7NJrfw7rOPyxDlSaT0P2NeC4=";
    })
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
