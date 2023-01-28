{ lib
, stdenv
, affine
, attrs
, boto3
, buildPythonPackage
, click
, click-plugins
, cligj
, cython
, fetchFromGitHub
, gdal
, hypothesis
, matplotlib
, numpy
, packaging
, pytest-randomly
, pytestCheckHook
, pythonOlder
, setuptools
, shapely
, snuggs
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "4"; 
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rasterio";
    repo = "rasterio";
    rev = "refs/tags/${version}";
    hash = "sha256-YO0FnmIEt+88f6k2mdXDSQg7UKq1Swr8wqVUGdRyQR4=";
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
    setuptools # needs pkg_resources at runtime
  ];

  nativeCheckInputs = [
    hypothesis
    packaging
    pytest-randomly
    pytestCheckHook
    shapely
  ];

  preCheck = ''
    rm -rf rasterio
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

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/rio --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    homepage = "https://rasterio.readthedocs.io/";
    changelog = "https://github.com/rasterio/rasterio/blob/1.3.5/CHANGES.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mredaelli ];
  };
}
