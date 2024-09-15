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
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Toblerity";
    repo = "Fiona";
    rev = "refs/tags/${version}";
    hash = "sha256-0Jiyq9x9YLDN1a1LBlCK2ac6kLZ5X2rOPusUQH5OPrQ=";
  };

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
  ] ++ optional-dependencies.s3;

  preCheck = ''
    rm -r fiona # prevent importing local fiona
  '';

  pytestFlagsArray = [
    # Tests with gdal marker do not test the functionality of Fiona,
    # but they are used to check GDAL driver capabilities.
    "-m 'not gdal'"
  ];

  disabledTests = [
    # Some tests access network, others test packaging
    "http"
    "https"
    "wheel"

    # see: https://github.com/Toblerity/Fiona/issues/1273
    "test_append_memoryfile_drivers"
  ];

  pythonImportsCheck = [ "fiona" ];

  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/Toblerity/Fiona/blob/${src.rev}/CHANGES.txt";
    description = "OGR's neat, nimble, no-nonsense API for Python";
    mainProgram = "fio";
    homepage = "https://fiona.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.geospatial.members;
  };
}
