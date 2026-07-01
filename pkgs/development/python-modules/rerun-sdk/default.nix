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
  av,
  datafusion,
  inline-snapshot,
  polars,
  pytest-snapshot,
  pytestCheckHook,
  rerun-notebook,
  tomli,
  torch,
  torchvision,
}:

buildPythonPackage {
  pname = "rerun-sdk";
  pyproject = true;
  __structuredAttrs = true;

  inherit (rerun)
    src
    version
    cargoDeps
    ;

  postPatch =
    (rerun.postPatch or "")

    # error: failed to parse contents of PYO3_CONFIG_FILE
    #
    # The pyo3 config file is supposed to be generated beforehand by invoking pixi.
    # As the only goal of this file is to enhance build caching, it is not worth bothering with it.
    # See https://github.com/rerun-io/rerun/blob/0.29.0/BUILD.md#pythonpyo3-configuration-important
    + ''
      substituteInPlace .cargo/config.toml \
        --replace-fail \
          "PYO3_CONFIG_FILE" \
          "# PYO3_CONFIG_FILE"
    '';

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
    av
    datafusion
    inline-snapshot
    polars
    pytest-snapshot
    pytestCheckHook
    rerun-notebook
    tomli
    torch
    torchvision
  ];

  inherit (rerun) addDlopenRunpaths addDlopenRunpathsPhase;
  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "addDlopenRunpathsPhase" ];

  disabledTests = [
    # ConnectionError: Connection: connecting to server: transport error
    "test_decode_matrix"
    "test_fixed_rate_sampling_duplicates_decode_correctly"
    "test_isolated_streams"
    "test_off_grid_capture_rate_decodes_correctly"
    "test_save_screenshot"
    "test_send_dataframe_roundtrip"
    "test_server_failed_table_creation_does_not_leak_entry"
    "test_server_version_info"
    "test_server_with_dataset_files"
    "test_server_with_dataset_prefix"
    "test_server_with_multiple_datasets"
    "test_viewer_dies_on_client_close"

    # TypeError: 'Snapshot' object is not callable
    "test_chunk_record_batch"
    "test_schema_recording"

    # pytest_snapshot mismatch: serialized schema/summary output drifted in 0.32.0
    "test_schema"
    "test_summary_format"

    # AttributeError: 'datetime.datetime' object has no attribute 'value'
    "test_lenses_time_extraction"

    # av.InvalidDataError: the mp4 asset is a Git LFS pointer, not the real
    # video (rerun.src is fetched without fetchLFS).
    "test_anchor_path_decodes_mid_gop_target"
    "test_collect_optimize_video_stream_summary"
    "test_heuristic_fallback_when_is_keyframe_column_absent"
  ];

  disabledTestPaths = [
    # RuntimeError: MCAP error: Bad magic number. The .mcap test assets are
    # Git LFS pointer files, not real binaries (rerun.src is fetched without
    # fetchLFS).
    "rerun_py/tests/integration/test_mcap_reader.py"

    # "fixture 'benchmark' not found"
    "tests/python/log_benchmark/test_log_benchmark.py"
    "tests/python/log_benchmark/test_micro_benchmark.py"

    # ValueError: Failed to start Rerun server: Error loading RRD: couldn't decode "/build/source/tests/assets/rrd/dataset/file4.rrd"
    "rerun_py/tests/e2e_redap_tests"

    # ConnectionError: Connection: connecting to server: transport error
    "rerun_py/tests/api_sandbox/"

    # RuntimeError: Failed to load URDF file: No elements found
    "rerun_py/tests/unit/test_urdf_tree.py"
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
