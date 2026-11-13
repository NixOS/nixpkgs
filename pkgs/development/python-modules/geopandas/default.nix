{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  numpy,
  packaging,
  pandas,
  pyogrio,
  pyproj,
  shapely,

  # optional-dependencies
  folium,
  geoalchemy2,
  geopy,
  mapclassify,
  matplotlib,
  psycopg,
  pyarrow,
  scipy,
  sqlalchemy,
  xyzservices,

  # tests
  pytestCheckHook,
  rtree,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "geopandas";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KXFNAsbeDLUupQSFnUSrvnSXqr5b8WUeDYaFbBvj9Xo=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    numpy
    packaging
    pandas
    pyogrio
    pyproj
    shapely
  ];

  optional-dependencies = {
    all = [
      # prevent infinite recursion
      (folium.overridePythonAttrs (prevAttrs: {
        doCheck = false;
      }))
      geoalchemy2
      geopy
      # prevent infinite recursion
      (mapclassify.overridePythonAttrs (prevAttrs: {
        doCheck = false;
      }))
      matplotlib
      psycopg
      pyarrow
      scipy
      sqlalchemy
      xyzservices
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    rtree
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  disabledTests = [
    # Requires network access
    "test_read_file_url"

    # Require geodatasets (circular dependency)
    "TestAxisLabels"
    "TestStyleMapping"

    # shapely.__version__ is "0+unknown" in nixpkgs, so pyogrio rejects `mask`:
    # ValueError: 'mask' parameter requires Shapely >= 2.0
    "test_read_file_crs_warning_messages"
    "test_read_file_mask"
    "test_read_file_multi_layer_with_layer_arg_no_warning"

    # GDAL shares pyarrow's libarrow and leaves a `geoarrow.wkb` extension type registered,
    # breaking the subsequent test_geoarrow.py tests
    "test_write_parquet_2_0_gdal_readable"
  ];

  enabledTestPaths = [ "geopandas" ];

  pythonImportsCheck = [ "geopandas" ];

  meta = {
    description = "Python geospatial data analysis framework";
    homepage = "https://geopandas.org";
    changelog = "https://github.com/geopandas/geopandas/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
})
