{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  gdal,
  numpy,
  setuptools,

  # dependencies
  affine,
  attrs,
  certifi,
  click,
  click-plugins,
  cligj,
  snuggs,

  # optional-dependencies
  ipython,
  matplotlib,
  boto3,

  # tests
  fsspec,
  hypothesis,
  packaging,
  pytestCheckHook,
  pytest-randomly,
  shapely,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rasterio";
    repo = "rasterio";
    tag = version;
    hash = "sha256-InejYBRa4i0E2GxEWbtBpaErtcoYrhtypAlRtMlUoDk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "cython~=3.0.2" cython
  '';

  build-system = [
    cython
    gdal
    numpy
    setuptools
  ];

  dependencies = [
    affine
    attrs
    certifi
    click
    click-plugins
    cligj
    numpy
    snuggs
  ];

  optional-dependencies = {
    ipython = [ ipython ];
    plot = [ matplotlib ];
    s3 = [ boto3 ];
  };

  nativeCheckInputs = [
    boto3
    fsspec
    hypothesis
    packaging
    pytestCheckHook
    pytest-randomly
    shapely
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  preCheck = ''
    rm -r rasterio # prevent importing local rasterio
  '';

  disabledTestMarks = [ "network" ];

  disabledTests = [
    # flaky
    "test_outer_boundless_pixel_fidelity"
    # network access
    "test_issue1982"
    "test_opener_fsspec_http_fs"
    "test_fsspec_http_msk_sidecar"
    # expect specific magic numbers that our version of GDAL does not produce
    "test_warp"
    "test_warpedvrt"
    "test_rio_warp"

    # AssertionError CLI exists with non-zero error code
    # This is a regression introduced by https://github.com/NixOS/nixpkgs/pull/448189
    "test_sample_stdin"
    "test_transform"
    "test_transform_point"
    "test_transform_point_dst_file"
    "test_transform_point_multi"
    "test_transform_point_src_file"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_reproject_error_propagation" ];

  pythonImportsCheck = [ "rasterio" ];

  meta = {
    description = "Python package to read and write geospatial raster data";
    mainProgram = "rio";
    homepage = "https://rasterio.readthedocs.io/";
    changelog = "https://github.com/rasterio/rasterio/blob/${version}/CHANGES.txt";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
}
