{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  stdenv,
  testers,

  affine,
  attrs,
  boto3,
  certifi,
  click,
  click-plugins,
  cligj,
  cython,
  fsspec,
  gdal,
  hypothesis,
  ipython,
  matplotlib,
  numpy,
  packaging,
  pytest-randomly,
  setuptools,
  shapely,
  snuggs,
  wheel,

  rasterio, # required to run version test
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rasterio";
    repo = "rasterio";
    rev = "refs/tags/${version}";
    hash = "sha256-YGSd0IG6TWnHmDiVEE3F2KNQ4dXJhkPqAJsIrWyuHos=";
  };

  nativeBuildInputs = [
    cython
    gdal
    numpy
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
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
  ];

  preCheck = ''
    rm -r rasterio # prevent importing local rasterio
  '';

  pytestFlagsArray = [ "-m 'not network'" ];

  disabledTests = [
    # flaky
    "test_outer_boundless_pixel_fidelity"
    # network access
    "test_issue1982"
    "test_opener_fsspec_http_fs"
    "test_fsspec_http_msk_sidecar"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_reproject_error_propagation" ];

  pythonImportsCheck = [ "rasterio" ];

  passthru.tests.version = testers.testVersion {
    package = rasterio;
    version = version;
    command = "${rasterio}/bin/rio --version";
  };

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    mainProgram = "rio";
    homepage = "https://rasterio.readthedocs.io/";
    changelog = "https://github.com/rasterio/rasterio/blob/${version}/CHANGES.txt";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
