{
  lib,
  stdenv,
  buildPythonPackage,
  rerun,
  python,

  # nativeBuildInputs
  rustPlatform,

  # dependencies
  attrs,
  numpy,
  opencv4,
  pillow,
  pyarrow,
  semver,
  typing-extensions,

  # tests
  datafusion,
  pytestCheckHook,
  torch,
}:

buildPythonPackage {
  pname = "rerun-sdk";
  pyproject = true;

  inherit (rerun)
    src
    version
    cargoDeps
    postPatch
    ;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rerun
  ];

  dependencies = [
    attrs
    numpy
    opencv4
    pillow
    pyarrow
    semver
    typing-extensions
  ];

  buildAndTestSubdir = "rerun_py";

  # https://github.com/NixOS/nixpkgs/issues/289340
  #
  # Alternatively, one could
  # dontUsePythonImportsCheck = true;
  # dontUsePytestCheck = true;
  postInstall = ''
    rm $out/${python.sitePackages}/rerun_sdk.pth
    ln -s rerun_sdk/rerun $out/${python.sitePackages}/rerun
  '';

  pythonImportsCheck = [ "rerun" ];

  nativeCheckInputs = [
    datafusion
    pytestCheckHook
    torch
  ];

  inherit (rerun) addDlopenRunpaths addDlopenRunpathsPhase;
  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "addDlopenRunpathsPhase" ];

  disabledTestPaths = [
    # "fixture 'benchmark' not found"
    "tests/python/log_benchmark/test_log_benchmark.py"

    # ConnectionError: Connection error: transport error
    "rerun_py/tests/unit/test_datafusion_tables.py"
  ];

  meta = {
    description = "Python bindings for `rerun` (an interactive visualization tool for stream data)";
    inherit (rerun.meta)
      changelog
      homepage
      license
      maintainers
      ;
    mainProgram = "rerun";
  };
}
