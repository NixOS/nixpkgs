{
  lib,
  stdenv,
  pkgs,
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
  tomli,
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
    pkgs.protobuf # for protoc
    rerun
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
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
    tomli
    torch
  ];

  inherit (rerun) addDlopenRunpaths addDlopenRunpathsPhase;
  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "addDlopenRunpathsPhase" ];

  disabledTestPaths = [
    # "fixture 'benchmark' not found"
    "tests/python/log_benchmark/test_log_benchmark.py"

    # ValueError: Failed to start Rerun server: Error loading RRD: couldn't decode "/build/source/tests/assets/rrd/dataset/file4.rrd"
    "rerun_py/tests/e2e_redap_tests"
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
