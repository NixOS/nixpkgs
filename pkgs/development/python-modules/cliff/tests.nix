{
  buildPythonPackage,
  cliff,
  sphinx,
  stestrCheckHook,
  testscenarios,
}:

buildPythonPackage {
  pname = "cliff";
  inherit (cliff) version src patches;
  pyproject = false;

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    cliff
    sphinx
    stestrCheckHook
    testscenarios
  ];

  # Incompatible with the cmd2 version in nixpkgs (Cmd.completenames removed);
  # fixed upstream in cliff 4.15.0.
  disabledTests = [
    "cliff.tests.test_help.TestHelp.test_show_help_for_help"
    "cliff.tests.test_interactive.TestInteractive.test_both_completenames"
    "cliff.tests.test_interactive.TestInteractive.test_cliff_completenames"
    "cliff.tests.test_interactive.TestInteractive.test_cmd2_completenames"
    "cliff.tests.test_interactive.TestInteractive.test_no_completenames"
  ];
}
