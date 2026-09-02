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
  pillow,
  psutil,
  pyarrow,
  typing-extensions,

  # tests
  av,
  datafusion,
  inline-snapshot,
  polars,
  pytestCheckHook,
  rerun-notebook,
  semver,
  syrupy,
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
    ''

    # `lance-linalg` (reachable only through `rerun_py`'s `re_server` "lance" feature, hence the
    # plain `rerun` CLI is unaffected) has AVX-512 VNNI u8-distance kernels that call
    # `_mm512_dpbusd_epi32`.
    # With the current toolchain, stdarch's signature for that intrinsic mismatches LLVM's
    # `llvm.x86.avx512.vpdpbusd.512`, so the crate fails to compile.
    # Drop the AVX-512 VNNI dispatch branch: the kernels then become dead code (their module is
    # crate-private and otherwise only used from `#[cfg(test)]`, which is not built for
    # dependencies), so they are never codegen'd and runtime dispatch falls back to the equivalent
    # AVX2 / scalar kernels.
    + ''
      lanceDistance="$cargoDepsCopy/source-registry-0/lance-linalg-9.0.0/src/distance"

      substituteInPlace "$lanceDistance/dot_u8.rs" \
        --replace-fail "return |a, b| unsafe { x86::dot_u8_avx512_vnni(a, b) };" ""

      substituteInPlace "$lanceDistance/l2_u8.rs" \
        --replace-fail "return |a, b| unsafe { x86::l2_u8_avx512_vnni(a, b) };" ""

      substituteInPlace "$lanceDistance/cosine_u8.rs" \
        --replace-fail "return |a, b| unsafe { x86::cosine_u8_accum_avx512_vnni(a, b) };" ""
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
    pillow
    psutil
    pyarrow
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
    pytestCheckHook
    rerun-notebook
    semver
    syrupy
    tomli
    torch
    torchvision
  ];

  inherit (rerun) addDlopenRunpaths addDlopenRunpathsPhase;
  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "addDlopenRunpathsPhase" ];

  pytestFlags = [
    # Some checked-in `.ambr` entries belong to tests skipped below (and to tests upstream has since
    # removed). syrupy fails the whole session over unused snapshots by default.
    "--snapshot-warn-unused"
  ];

  disabledTests = [
    # RuntimeError: MP4 error: MP4 demux: MP4 error: file contains a box with a larger size than it
    "test_asset_mode_timeline_type_timestamp_applies_to_index_chunk"
    "test_custom_entity_path_applies_to_every_chunk"
    "test_default_mode_produces_video_stream_chunks"
    "test_optimize_only_coarsens_the_readers_gop_partition"
    "test_output_codec_same_as_source_stays_on_the_direct_path"
    "test_stream_mode_chunk_by_gop_false_emits_one_sample_per_chunk"
    "test_stream_mode_chunk_by_gop_true_packs_multiple_samples"
    "test_timeline_type_timestamp_produces_timestamp_typed_column"

    # ConnectionError: Connection: connecting to server: transport error
    "test_batch_shape"
    "test_isolated_streams"
    "test_roundtrip_parity"
    "test_save_screenshot"
    "test_send_dataframe_roundtrip"
    "test_server_failed_table_creation_does_not_leak_entry"
    "test_server_version_info"
    "test_server_with_dataset_files"
    "test_server_with_dataset_prefix"
    "test_server_with_multiple_datasets"
    "test_viewer_dies_on_client_close"

    # AttributeError: 'datetime.datetime' object has no attribute 'value'
    "test_lenses_time_extraction"

    # av.InvalidDataError: the mp4 asset is a Git LFS pointer, not the real
    # video (rerun.src is fetched without fetchLFS).
    "test_collect_optimize_video_stream_summary"

    # AssertionError: the Git LFS pointer mp4 asset fails to demux before the
    # expected "FFmpeg executable not found" error can be raised, so the
    # pytest.raises regex does not match (rerun.src is fetched without fetchLFS).
    "test_b_frames_without_ffmpeg_reports_missing_ffmpeg"
  ];

  disabledTestPaths = [
    # av.InvalidDataError: every test builds its recording from the mp4 asset, which is a Git LFS
    # pointer, not the real video (rerun.src is fetched without fetchLFS).
    "rerun_py/tests/integration/test_dataloader_video.py"

    # ConnectionError: Connection: connecting to server: transport error
    "rerun_py/tests/integration/test_dataloader_video_codecs.py"

    # RuntimeError: MCAP error: Bad magic number. The .mcap test assets are
    # Git LFS pointer files, not real binaries (rerun.src is fetched without
    # fetchLFS).
    "rerun_py/tests/integration/test_mcap_reader.py"

    # RuntimeError: Failed to open the HDF5 file: HDF5 format error: HDF5
    # signature not found. The .h5 test assets are Git LFS pointer files, not
    # real binaries (rerun.src is fetched without fetchLFS).
    "rerun_py/tests/integration/test_hdf5_reader.py"

    # ModuleNotFoundError: No module named 'mdlint'. It sits next to the test file, which is
    # not on `sys.path` as `scripts/ci` has no `__init__.py`.
    "scripts/ci/mdlint_test.py"

    # "fixture 'benchmark' not found"
    "tests/python/log_benchmark/test_log_benchmark.py"
    "tests/python/log_benchmark/test_micro_benchmark.py"

    # ValueError: Failed to start Rerun server: Error loading RRD: couldn't decode "/build/source/tests/assets/rrd/dataset/file4.rrd"
    "rerun_py/tests/e2e_redap_tests"

    # ConnectionError: Connection: connecting to server: transport error
    "rerun_py/tests/api_sandbox/"

    # RuntimeError: Failed to load URDF file: No elements found. `so100.urdf` is a Git LFS
    # pointer file, not the real model (rerun.src is fetched without fetchLFS).
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
