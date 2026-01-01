{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
  taskwarrior3,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  setuptools,
  click,
  dogpile-cache,
  importlib-metadata,
  jinja2,
  lockfile,
  pydantic,
  python-dateutil,
  pytz,
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
  sphinx,
  sphinx-click,
  sphinx-inline-tabs,
=======
  fetchPypi,
  pythonOlder,
  setuptools,
  twiggy,
  requests,
  offtrac,
  python-bugzilla,
  taskw,
  python-dateutil,
  pytz,
  keyring,
  six,
  jinja2,
  pycurl,
  dogpile-cache,
  lockfile,
  click,
  pyxdg,
  future,
  jira,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "bugwarrior";
<<<<<<< HEAD
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "bugwarrior";
    tag = version;
    hash = "sha256-VuHTrkxLZmQOxyig2krVU9UZDDbLY08MfB9si08lh3E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    dogpile-cache
    importlib-metadata
    jinja2
    lockfile
    pydantic
    python-dateutil
    pytz
    requests
    taskw
  ]
  ++ pydantic.optional-dependencies.email;
  pythonRemoveDeps = [ "tomli" ];

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
=======
  version = "1.8.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f024c29d2089b826f05481cace33a62aa984f33e98d226f6e41897e6f11b3f51";
  };

  propagatedBuildInputs = [
    setuptools
    twiggy
    requests
    offtrac
    python-bugzilla
    taskw
    python-dateutil
    pytz
    keyring
    six
    jinja2
    pycurl
    dogpile-cache
    lockfile
    click
    pyxdg
    future
    jira
  ];

  # for the moment oauth2client <4.0.0 and megaplan>=1.4 are missing for running the test suite.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/GothenburgBitFactory/bugwarrior";
    description = "Sync github, bitbucket, bugzilla, and trac issues with taskwarrior";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pierron ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
