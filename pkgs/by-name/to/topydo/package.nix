{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  glibcLocales,
}:

python3Packages.buildPythonApplication rec {
  pname = "topydo";
  version = "0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "topydo";
    repo = "topydo";
    tag = version;
    hash = "sha256-y5sq8zVSCcTmpa+OCIo4KxvUVlOz1vezcyC5C6Jq7tI=";
  };

  build-system = [ python3Packages.setuptools ];

  patches = [
    # fixes a failing test
    (fetchpatch {
      name = "update-a-test-reference-ics-file.patch";
      url = "https://github.com/topydo/topydo/commit/9373bb4702b512b10f0357df3576c129901e3ac6.patch";
      hash = "sha256-JpyQfryWSoJDdyzbrESWY+RmRbDw1myvTlsFK7+39iw=";
    })
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

  LC_ALL = "en_US.UTF-8";

  meta = {
    description = "Cli todo application compatible with the todo.txt format";
    mainProgram = "topydo";
    homepage = "https://github.com/topydo/topydo";
    changelog = "https://github.com/topydo/topydo/blob/${version}/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
