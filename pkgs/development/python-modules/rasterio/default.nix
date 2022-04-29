{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build time
, cython
, gdal

# runtime
, affine
, attrs
, boto3
, click
, click-plugins
, cligj
, matplotlib
, numpy
, snuggs

# tests
, hypothesis
, packaging
, pytest-randomly
, pytestCheckHook
, shapely
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.2.10"; # not x.y[ab]z, those are alpha/beta versions
  format = "pyproject";
  disabled = pythonOlder "3.6";

  # Pypi doesn't ship the tests, so we fetch directly from GitHub
  src = fetchFromGitHub {
    owner = "rasterio";
    repo = "rasterio";
    rev = version;
    hash = "sha256-xVGwQfQvxsqYihUYXENJAz9Qp9xBkhsGc/RheRTJxgo=";
  };

  nativeBuildInputs = [
    cython
    gdal
  ];

  propagatedBuildInputs = [
    affine
    attrs
    boto3
    click
    click-plugins
    cligj
    matplotlib
    numpy
    snuggs
  ];

  preCheck = ''
    rm -rf rasterio
  '';

  checkInputs = [
    pytest-randomly
    pytestCheckHook
    packaging
    hypothesis
    shapely
  ];

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  pythonImportsCheck = [
    "rasterio"
  ];

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    homepage = "https://rasterio.readthedocs.io/en/latest/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mredaelli ];
  };
}
