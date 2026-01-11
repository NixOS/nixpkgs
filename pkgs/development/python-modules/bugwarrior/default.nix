{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  taskwarrior3,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  setuptools,
  click,
  dogpile-cache,
  jinja2,
  lockfile,
  pydantic,
  python-dateutil,
  requests,
  taskw,
  debianbts,
  python-bugzilla,
  google-api-python-client,
  google-auth-oauthlib,
  jira,
  keyring,
  offtrac,
  pytestCheckHook,
  docutils,
  pytest-subtests,
  responses,
  ruff,
  sphinx,
  sphinx-click,
  sphinx-inline-tabs,
}:

buildPythonPackage rec {
  pname = "bugwarrior";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "bugwarrior";
    tag = version;
    hash = "sha256-Px0yOIdXalIJdXMmjMnpl74aaUzaptS8Esy21NMZH98=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    dogpile-cache
    jinja2
    lockfile
    pydantic
    python-dateutil
    requests
    taskw
  ]
  ++ pydantic.optional-dependencies.email;

  optional-dependencies = {
    bts = [ debianbts ];
    bugzilla = [ python-bugzilla ];
    gmail = [
      google-api-python-client
      google-auth-oauthlib
    ];
    jira = [ jira ];
    keyring = [ keyring ];
    trac = [ offtrac ];
  };

  nativeCheckInputs = [
    taskwarrior3
    versionCheckHook
    writableTmpDirAsHomeHook
    pytestCheckHook
    docutils
    pytest-subtests
    responses
    ruff
    sphinx
    sphinx-click
    sphinx-inline-tabs
  ]
  ++ lib.concatAttrValues optional-dependencies;
  disabledTestPaths = [
    # Optional dependencies for these services aren't packaged.
    "tests/test_kanboard.py"
    "tests/test_phab.py"
    "tests/test_todoist.py"
  ];
  disabledTests = [
    # Requires ini2toml dependency, which isn't packaged.
    "TestIni2Toml"
    # Import services for which the optional dependencies aren't packaged.
    "TestValidation"
    "ExampleTest"
    "TestServices"
  ];

  pythonImportsCheck = [ "bugwarrior" ];

  meta = {
    homepage = "https://github.com/GothenburgBitFactory/bugwarrior";
    description = "Sync github, bitbucket, bugzilla, and trac issues with taskwarrior";
    changelog = "https://github.com/GothenburgBitFactory/bugwarrior/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "bugwarrior";
    maintainers = with lib.maintainers; [
      pierron
      ryneeverett
    ];
  };
}
