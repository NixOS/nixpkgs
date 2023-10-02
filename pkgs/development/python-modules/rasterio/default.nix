{ lib
, stdenv
, affine
, attrs
, boto3
, buildPythonPackage
, click
, click-plugins
, cligj
, certifi
, cython
, fetchFromGitHub
, gdal
, hypothesis
, matplotlib
, ipython
, numpy
, oldest-supported-numpy
, packaging
, pytest-randomly
, pytestCheckHook
, pythonOlder
, setuptools
, shapely
, snuggs
, wheel
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.3.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rasterio";
    repo = "rasterio";
    rev = "refs/tags/${version}";
    hash = "sha256-8kPzUvTZ/jRDXlYMAZkG1xdLAQuzxnvHXBzwWizMOTo=";
  };

  nativeBuildInputs = [
    cython
    gdal
    numpy
    oldest-supported-numpy
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    affine
    attrs
    click
    click-plugins
    cligj
    certifi
    numpy
    snuggs
    setuptools
  ];

  passthru.optional-dependencies = {
    ipython = [
      ipython
    ];
    plot = [
      matplotlib
    ];
    s3 = [
      boto3
    ];
  };

  nativeCheckInputs = [
    boto3
    hypothesis
    packaging
    pytest-randomly
    pytestCheckHook
    shapely
  ];

  doCheck = true;

  preCheck = ''
    rm -r rasterio # prevent importing local rasterio
  '';

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_reproject_error_propagation"
  ];

  pythonImportsCheck = [
    "rasterio"
  ];

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    homepage = "https://rasterio.readthedocs.io/";
    changelog = "https://github.com/rasterio/rasterio/blob/${version}/CHANGES.txt";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
