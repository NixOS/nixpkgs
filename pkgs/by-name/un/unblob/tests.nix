{
  python3,
  unblob,
}:

python3.pkgs.buildPythonPackage {
  pname = "unblob-tests";
  inherit (unblob) version src;
  format = "other";
  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs =
    with python3.pkgs;
    [
      pytestCheckHook
      pytest-cov-stub
      unblob
    ]
    ++ unblob.runtimeDeps;

  pytestFlagsArray = [
    "--no-cov"
    # `disabledTests` swallows the parameters between square brackets
    # https://github.com/tytso/e2fsprogs/issues/152
    "-k 'not test_all_handlers[filesystem.extfs]'"
  ];
}
