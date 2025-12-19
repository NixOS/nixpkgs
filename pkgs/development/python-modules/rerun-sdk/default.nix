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
  inline-snapshot,
  polars,
  pytest-snapshot,
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
    inline-snapshot
    polars
    pytest-snapshot
    pytestCheckHook
    tomli
    torch
  ];

  inherit (rerun) addDlopenRunpaths addDlopenRunpathsPhase;
  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "addDlopenRunpathsPhase" ];

  disabledTests = [
    # ConnectionError: Connection: connecting to server: transport error
    "test_isolated_streams"
    "test_send_dataframe_roundtrip"
    "test_server_with_dataset_files"
    "test_server_with_dataset_prefix"
    "test_server_with_multiple_datasets"

    # TypeError: 'Snapshot' object is not callable
    "test_schema_recording"
  ];

  disabledTestPaths = [
    # "fixture 'benchmark' not found"
    "tests/python/log_benchmark/test_log_benchmark.py"

    # ValueError: Failed to start Rerun server: Error loading RRD: couldn't decode "/build/source/tests/assets/rrd/dataset/file4.rrd"
    "rerun_py/tests/e2e_redap_tests"

    # ConnectionError: Connection: connecting to server: transport error
    "rerun_py/tests/api_sandbox/"
  ];

  __darwinAllowLocalNetworking = true;

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
