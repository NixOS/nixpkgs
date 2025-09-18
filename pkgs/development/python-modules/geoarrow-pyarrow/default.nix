{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  geoarrow-c,
  pyarrow,
  pyarrow-hotfix,
  numpy,
  pandas,
  geopandas,
  pyogrio,
  pyproj,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "geoarrow-pyarrow";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "geoarrow-python";
    owner = "geoarrow";
    tag = "geoarrow-pyarrow-${version}";
    hash = "sha256-Ni+GKTRhRDRHip1us3OZPuUhHQCNU7Nap865T/+CU8Y=";
  };

  sourceRoot = "${src.name}/geoarrow-pyarrow";

  build-system = [ setuptools-scm ];

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

  dependencies = [
    geoarrow-c
    pyarrow
    pyarrow-hotfix
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    pandas
    geopandas
    pyogrio
    pyproj
  ];

  pythonImportsCheck = [ "geoarrow.pyarrow" ];

  meta = with lib; {
    description = "PyArrow implementation of geospatial data types";
    homepage = "https://github.com/geoarrow/geoarrow-python";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cpcloud
    ];
    teams = [ lib.teams.geospatial ];
  };
}
