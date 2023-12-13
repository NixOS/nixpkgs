{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
, stdenv

, affine
, attrs
, boto3
, certifi
, click
, click-plugins
, cligj
, cython_3
, gdal
, hypothesis
, ipython
, matplotlib
, numpy
, oldest-supported-numpy
, packaging
, pytest-randomly
, setuptools
, shapely
, snuggs
, wheel
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.3.9";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rasterio";
    repo = "rasterio";
    rev = "refs/tags/${version}";
    hash = "sha256-Tp6BSU33FaszrIXQgU0Asb7IMue0C939o/atAKz+3Q4=";
  };

  patches = [
    # fix tests failing with GDAL 3.8.0
    (fetchpatch {
      url = "https://github.com/rasterio/rasterio/commit/54ec554a6d9ee52207ad17dee42cbc51c613f709.diff";
      hash = "sha256-Vjt9HRYNAWyj0myMdtSUENbcLjACfzegEClzZb4BxY8=";
    })
    (fetchpatch {
      url = "https://github.com/rasterio/rasterio/commit/5a72613c58d1482bf297d08cbacf27992f52b2c4.diff";
      hash = "sha256-bV6rh3GBmeqq9+Jff2b8/1wOuyF3Iqducu2eN4CT3lM=";
    })
  ];

  nativeBuildInputs = [
    cython_3
    gdal
    numpy
    oldest-supported-numpy
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
    setuptools
    snuggs
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
    pytestCheckHook
    pytest-randomly
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
