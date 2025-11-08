{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  click,

  # tests
  hypothesis,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "mercantile";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "mercantile";
    tag = version;
    hash = "sha256-DiDXO2XnD3We6NhP81z7aIHzHrHDi/nkqy98OT9986w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    click
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  disabledTests = [
    # AssertionError CLI exists with non-zero error code
    # This is a regression introduced by https://github.com/NixOS/nixpkgs/pull/448189
    "test_cli_bounding_tile"
    "test_cli_bounding_tile2"
    "test_cli_bounding_tile_bbox"
    "test_cli_bounding_tile_geosjon"
    "test_cli_children"
    "test_cli_multi_bounding_tile"
    "test_cli_multi_bounding_tile_seq"
    "test_cli_neighbors"
    "test_cli_parent"
    "test_cli_parent_depth"
    "test_cli_parent_failure"
    "test_cli_parent_multidepth"
    "test_cli_quadkey_from_mixed"
    "test_cli_quadkey_from_quadkeys"
    "test_cli_quadkey_from_tiles"
    "test_cli_shapes"
    "test_cli_shapes_collect"
    "test_cli_shapes_compact"
    "test_cli_shapes_failure"
    "test_cli_shapes_indentation"
    "test_cli_strict_overlap_contain"
    "test_cli_tiles_bad_bounds"
    "test_cli_tiles_bounding_tiles_seq"
    "test_cli_tiles_bounding_tiles_z0"
    "test_cli_tiles_geosjon"
    "test_cli_tiles_implicit_stdin"
    "test_cli_tiles_multi_bounds"
    "test_cli_tiles_multi_bounds_seq"
    "test_cli_tiles_no_bounds"
    "test_cli_tiles_point_geojson"
    "test_cli_tiles_points"
    "test_cli_tiles_seq"
  ];

  meta = {
    description = "Spherical mercator tile and coordinate utilities";
    mainProgram = "mercantile";
    homepage = "https://github.com/mapbox/mercantile";
    changelog = "https://github.com/mapbox/mercantile/blob/${version}/CHANGES.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
