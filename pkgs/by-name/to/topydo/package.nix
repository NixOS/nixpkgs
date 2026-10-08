{
  lib,
  python3Packages,
  fetchFromGitHub,
  glibcLocales,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "topydo";
  version = "0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "topydo";
    repo = "topydo";
    tag = finalAttrs.version;
    hash = "sha256-f31tp4VBMv1usViYN50IaGeyQpo3oRSf/WDz99UEpss=";
  };

  postPatch = ''
    # Strip deprecated pytest-runner from pyproject.toml build requirements
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["setuptools", "wheel", "pytest-runner"]' 'requires = ["setuptools", "wheel"]'
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    arrow
    glibcLocales
    icalendar
    prompt-toolkit
    urwid
    watchdog
  ];

  nativeCheckInputs = with python3Packages; [
    freezegun
    unittestCheckHook
  ];

  # Skip test that has been reported multiple times upstream without result:
  # bram85/topydo#271, bram85/topydo#274.
  preCheck = ''
    substituteInPlace test/test_revert_command.py --replace-fail 'test_revert_ls' 'dont_test_revert_ls'
  '';

  env.LC_ALL = "en_US.UTF-8";

  meta = {
    description = "Cli todo application compatible with the todo.txt format";
    mainProgram = "topydo";
    homepage = "https://github.com/topydo/topydo";
    changelog = "https://github.com/topydo/topydo/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
})
