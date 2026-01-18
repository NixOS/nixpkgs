{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  gdal,
  setuptools,

  # dependencies
  attrs,
  certifi,
  click,
  click-plugins,
  cligj,

  # optional-dependencies
  pyparsing,
  shapely,
  boto3,

  # tests
  fsspec,
  pytestCheckHook,
  pytz,
  snuggs,
}:

buildPythonPackage rec {
  pname = "fiona";
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Toblerity";
    repo = "Fiona";
    tag = version;
    hash = "sha256-5NN6PBh+6HS9OCc9eC2TcBvkcwtI4DV8qXnz4tlaMXc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "cython~=3.0.2" cython
  '';

  build-system = [
    cython
    gdal # for gdal-config
    setuptools
  ];

  buildInputs = [ gdal ];

  dependencies = [
    attrs
    certifi
    click
    click-plugins
    cligj
  ];

  optional-dependencies = {
    calc = [
      pyparsing
      shapely
    ];
    s3 = [ boto3 ];
  };

  nativeCheckInputs = [
    fsspec
    pytestCheckHook
    pytz
    shapely
    snuggs
  ]
  ++ optional-dependencies.s3;

  preCheck = ''
    rm -r fiona # prevent importing local fiona
  '';

  disabledTestMarks = [
    # Tests with gdal marker do not test the functionality of Fiona,
    # but they are used to check GDAL driver capabilities.
    "gdal"
  ];

  disabledTests = [
    # Some tests access network, others test packaging
    "http"
    "https"
    "wheel"

    # see: https://github.com/Toblerity/Fiona/issues/1273
    "test_append_memoryfile_drivers"

    # AssertionError CLI exists with non-zero error code
    # This is a regression introduced by https://github.com/NixOS/nixpkgs/pull/448189
    "test_bbox_json_yes"
    "test_bbox_no"
    "test_bbox_where"
    "test_bbox_yes"
    "test_bbox_yes_two_files"
    "test_bool_seq"
    "test_bounds_explode_with_obj"
    "test_calc_seq"
    "test_collect_ld"
    "test_collect_no_rs"
    "test_collect_noparse"
    "test_collect_noparse_records"
    "test_collect_noparse_rs"
    "test_collect_rec_buffered"
    "test_collect_rs"
    "test_creation_options"
    "test_different_crs"
    "test_distrib"
    "test_distrib_no_rs"
    "test_dst_crs_default_to_src_crs"
    "test_dst_crs_epsg3857"
    "test_dst_crs_no_src"
    "test_existing_property"
    "test_explode"
    "test_explode_output_rs"
    "test_explode_pp"
    "test_explode_with_id"
    "test_filter"
    "test_fio_load_layer"
    "test_fio_load_layer_append"
    "test_load__auto_detect_format"
    "test_load__auto_detect_format"
    "test_load__auto_detect_format"
    "test_load__auto_detect_format"
    "test_load__auto_detect_format"
    "test_map_count"
    "test_multi_layer"
    "test_one"
    "test_precision"
    "test_reduce_area"
    "test_reduce_area"
    "test_reduce_union"
    "test_reduce_union_zip_properties"
    "test_seq"
    "test_seq"
    "test_seq_no_rs"
    "test_seq_rs"
    "test_seq_rs"
    "test_two"
    "test_vfs"
    "test_where_no"
    "test_where_yes"
    "test_where_yes_two_files"
    "test_with_id"
    "test_with_obj"
  ];

  pythonImportsCheck = [ "fiona" ];

  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/Toblerity/Fiona/blob/${src.rev}/CHANGES.txt";
    description = "OGR's neat, nimble, no-nonsense API for Python";
    mainProgram = "fio";
    homepage = "https://fiona.readthedocs.io/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
