{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  geoarrow-c,
  geoarrow-types,
  pyarrow,
  pyarrow-hotfix,

  # tests
  geopandas,
  numpy,
  pandas,
  pyogrio,
  pyproj,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "geoarrow-pyarrow";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    repo = "geoarrow-python";
    owner = "geoarrow";
    tag = "geoarrow-types-${finalAttrs.version}";
    hash = "sha256-ciElwh94ukFyFdOBuQWyOUVpn4jBM1RKfxiBCcM+nmE=";
  };

  sourceRoot = "${finalAttrs.src.name}/geoarrow-pyarrow";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    geoarrow-c
    geoarrow-types
    pyarrow
    pyarrow-hotfix
  ];

  pythonImportsCheck = [ "geoarrow.pyarrow" ];

  nativeCheckInputs = [
    geopandas
    numpy
    pandas
    pyogrio
    pyproj
    pytestCheckHook
  ];

  disabledTests = [
    # these tests are incompatible with arrow 17
    "test_make_point"
    "test_point_with_offset"
    "test_linestring_with_offset"
    "test_polygon_with_offset"
    "test_multipoint_with_offset"
    "test_multilinestring_with_offset"
    "test_multipolygon_with_offset"
    "test_multipolygon_with_offset_nonempty_inner_lists"
    "test_interleaved_multipolygon_with_offset"
    "test_readpyogrio_table_gpkg"
    "test_geometry_type_basic"
  ];

  meta = {
    description = "PyArrow implementation of geospatial data types";
    homepage = "https://github.com/geoarrow/geoarrow-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cpcloud
    ];
    teams = [ lib.teams.geospatial ];
  };
})
