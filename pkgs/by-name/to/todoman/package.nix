{
  fetchFromGitHub,
  installShellFiles,
  jq,
  lib,
  python3,
  sphinxHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "todoman";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = "todoman";
    rev = "refs/tags/v${version}";
    hash = "sha256-sk5LgFNo5Dc+oHCLu464Q1g0bk1QGsA7xMtMiits/8c=";
  };

  nativeBuildInputs = [
    installShellFiles
    sphinxHook
    python3.pkgs.sphinx-click
    python3.pkgs.sphinx-rtd-theme
  ];

  build-system = with python3.pkgs; [
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    atomicwrites
    click
    click-log
    click-repl
    humanize
    icalendar
    parsedatetime
    pyxdg
    tabulate
    urwid
  ];

  nativeCheckInputs = with python3.pkgs; [
    freezegun
    hypothesis
    pytest-cov-stub
    pytestCheckHook
    pytz
  ];

  postInstall = ''
    installShellCompletion --bash contrib/completion/bash/_todo
    substituteInPlace contrib/completion/zsh/_todo --replace "jq " "${lib.getExe jq} "
    installShellCompletion --zsh contrib/completion/zsh/_todo
  '';

  disabledTests = [
    # Testing of the CLI part and output
    "test_color_due_dates"
    "test_color_flag"
    "test_default_command"
    "test_main"
    "test_missing_cache_dir"
    "test_sorting_null_values"
    "test_xdg_existant"
    # Tests are sensitive to performance
    "test_sorting_fields"
  ];

  pythonImportsCheck = [
    "todoman"
  ];

  meta = {
    homepage = "https://github.com/pimutils/todoman";
    description = "Standards-based task manager based on iCalendar";
    longDescription = ''
      Todoman is a simple, standards-based, cli todo (aka task) manager. Todos
      are stored into iCalendar files, which means you can sync them via CalDAV
      using, for example, vdirsyncer.

      Todos are read from individual ics files from the configured directory.
      This matches the vdir specification. There is support for the most common TODO
      features for now (summary, description, location, due date and priority) for
      now.
      Unsupported fields may not be shown but are never deleted or altered.
    '';
    changelog = "https://todoman.readthedocs.io/en/stable/changelog.html#v${
      builtins.replaceStrings [ "." ] [ "-" ] version
    }";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      leenaars
      antonmosich
    ];
    mainProgram = "todo";
  };
}
