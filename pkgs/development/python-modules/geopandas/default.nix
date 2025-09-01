{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    tag = "v${version}";
    hash = "sha256-7ZsO4jresikA17M8cyHskdcVnTscGHxTCLJv5p1SvfI=";
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

  meta = with lib; {
    description = "Python geospatial data analysis framework";
    homepage = "https://geopandas.org";
    changelog = "https://github.com/geopandas/geopandas/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    teams = [ teams.geospatial ];
  };
}
