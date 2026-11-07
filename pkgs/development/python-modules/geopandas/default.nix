{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
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
    hatchling
    hatch-vcs
  ];

  dependencies = [
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
  ];

  disabledTestPaths = [
    # ValueError: 'mask' parameter requires Shapely >= 2.0
    "geopandas/io/tests/test_file.py"
    # ValueError: No geometry column found in the Arrow table.
    "geopandas/io/tests/test_geoarrow.py"
    # requires geodatasets, causing infinite recursion
    "geopandas/tests/test_plotting.py"
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
