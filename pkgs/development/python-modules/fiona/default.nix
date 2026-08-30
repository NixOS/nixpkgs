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
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fiona";
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Toblerity";
    repo = "Fiona";
    tag = finalAttrs.version;
    hash = "sha256-5NN6PBh+6HS9OCc9eC2TcBvkcwtI4DV8qXnz4tlaMXc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "cython~=3.0.2" cython
  ''
  +
    # pyparsing deprecated parseString in favor of parse_string
    ''
      substituteInPlace fiona/fio/features.py fiona/_vendor/snuggs.py \
        --replace-fail parseString parse_string
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

  pythonImportsCheck = [ "fiona" ];

  nativeCheckInputs = [
    fsspec
    pytestCheckHook
    pytz
    shapely
    snuggs
    versionCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.s3;

  # prevent importing local fiona
  preCheck = ''
    rm -r fiona
  '';

  disabledTestMarks = [
    # Tests with gdal marker do not test the functionality of Fiona,
    # but they are used to check GDAL driver capabilities.
    "gdal"
  ];

  pytestFlags = [
    # UserWarning: The parameter --where is used more than once. Remove its duplicate as parameters should be unique.
    "-Wignore::UserWarning"
  ];

  disabledTests = [
    # Some tests access network, others test packaging
    "http"
    "https"
    "wheel"

    # AssertionError: assert """"bool": true""" in data
    "test_write_bool_subtype"

    # AssertionError: assert '"coordinates": [ [ [ -111.74, 42.0 ], [ -111.66, 42.0 ]' in f.read(2000)
    "test_open_kwargs"

    # fiona.errors.DatasetDeleteError: Driver does not support dataset removal operation
    "test_remove"

    # see: https://github.com/Toblerity/Fiona/issues/1273
    "test_append_memoryfile_drivers"
  ];

  meta = {
    description = "OGR's neat, nimble, no-nonsense API for Python";
    changelog = "https://github.com/Toblerity/Fiona/blob/${finalAttrs.src.tag}/CHANGES.txt";
    mainProgram = "fio";
    homepage = "https://fiona.readthedocs.io/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
})
