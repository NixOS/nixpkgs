{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # tests
  versionCheckHook,

  # nativeBuildInputs for GUI
  gobject-introspection,
  wrapGAppsHook3,

  # dependencies (required for most functionality)
  pyicu,
  lxml,
  enableGui ? false,
  # for GUI only
  pygobject3,
  gtk3,
  enableCmd ? false,
  prompt-toolkit,
  tqdm,
}:

buildPythonPackage rec {
  pname = "pyglossary";
  version = "5.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ilius";
    repo = "pyglossary";
    tag = version;
    hash = "sha256-OrySbbStVSz+WF8D+ODK++lKfYJOm9KCfOxDP3snuKY=";
  };

  patches = [
    # Fixes a few install issues, can be removed in the next release. See:
    # https://github.com/ilius/pyglossary/pull/684
    (fetchpatch {
      url = "https://github.com/ilius/pyglossary/commit/f86c91ed987579cd8a1c7f7f278452901ce725ac.patch";
      hash = "sha256-ewYeNwD3/aSsNbMazgW/3tBpYAPBZdnVu9LCh7tQZjg=";
    })
  ];

  build-system = [
    setuptools
  ]
  ++ lib.optionals enableGui [
    gobject-introspection
    wrapGAppsHook3
  ];

  dependencies = [
    pyicu
    lxml
  ]
  ++ lib.optionals enableGui [
    pygobject3
  ]
  ++ lib.optionals enableCmd [
    prompt-toolkit
    tqdm
  ];

  buildInputs = lib.optionals enableGui [
    gtk3
  ];

  # Many issues with the tests: They require `cd tests` in `preCheck`; Some of
  # them depend upon files in `tests/deprecated`; Even with workarounds to
  # these 2 issues, many tests require network access. We don't enable the
  # tests by not adding pytestCheckHook to this list.
  nativeCheckInputs = [
    versionCheckHook
  ];
  env = {
    # The default --help creates permission errors that may be confusing when
    # observed in the build log.
    versionCheckProgramArg = "--version";
  };

  pythonImportsCheck = [
    "pyglossary"
  ];

  meta = {
    description = "Tool for converting dictionary files aka glossaries. Mainly to help use our offline glossaries in any Open Source dictionary we like on any operating system / device";
    homepage = "https://github.com/ilius/pyglossary";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "pyglossary";
  };
}
