{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit,

  # dependencies
  attrs,
  click,
  pydantic,
  pyproj,

  # tests
  mercantile,
  rasterio,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "morecantile";
  version = "6.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "morecantile";
    tag = version;
    hash = "sha256-ohTSgkjgaANS/Pli4fao+THA4ltts6svj5CdJEgorz0=";
  };

  build-system = [ flit ];

  dependencies = [
    attrs
    click
    pydantic
    pyproj
  ];

  nativeCheckInputs = [
    mercantile
    pytestCheckHook
    rasterio
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  disabledTests = [
    # AssertionError CLI exists with non-zero error code
    # This is a regression introduced by https://github.com/NixOS/nixpkgs/pull/448189
    "test_cli_shapes"
    "test_cli_shapesWGS84"
    "test_cli_strict_overlap_contain"
    "test_cli_tiles_bad_bounds"
    "test_cli_tiles_geosjon"
    "test_cli_tiles_implicit_stdin"
    "test_cli_tiles_multi_bounds"
    "test_cli_tiles_multi_bounds_seq"
    "test_cli_tiles_ok"
    "test_cli_tiles_points"
    "test_cli_tiles_seq"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/developmentseed/morecantile/issues/156
    "test_tiles_when_tms_bounds_and_provided_bounds_cross_antimeridian"
  ];

  pythonImportsCheck = [ "morecantile" ];

  meta = {
    description = "Construct and use map tile grids in different projection";
    homepage = "https://developmentseed.org/morecantile";
    downloadPage = "https://github.com/developmentseed/morecantile";
    changelog = "https://github.com/developmentseed/morecantile/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
    mainProgram = "morecantile";
  };
}
