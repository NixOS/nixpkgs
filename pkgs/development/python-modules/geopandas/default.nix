{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  setuptools,

  packaging,
  pandas,
  pyogrio,
  pyproj,
  rtree,
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
}:

buildPythonPackage rec {
  pname = "geopandas";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    tag = "v${version}";
    hash = "sha256-66FbHNewpSEVZ9RwngK7E4bcELa9Z2OQ9xVP9+fgeHQ=";
  };

  build-system = [ setuptools ];

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
  ]
  ++ optional-dependencies.all;

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Requires network access
    "test_read_file_url"
  ];

  enabledTestPaths = [ "geopandas" ];

  pythonImportsCheck = [ "geopandas" ];

  meta = {
    description = "Python geospatial data analysis framework";
    homepage = "https://geopandas.org";
    changelog = "https://github.com/geopandas/geopandas/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
