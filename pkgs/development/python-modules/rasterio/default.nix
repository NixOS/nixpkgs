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
<<<<<<< HEAD
, oldest-supported-numpy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, packaging
, pytest-randomly
, pytestCheckHook
, pythonOlder
, setuptools
, shapely
, snuggs
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "rasterio";
<<<<<<< HEAD
  version = "1.3.8";
=======
  version = "1.3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rasterio";
    repo = "rasterio";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-8kPzUvTZ/jRDXlYMAZkG1xdLAQuzxnvHXBzwWizMOTo=";
=======
    hash = "sha256-C5jenXcONNYiUNa5GQ7ATBi8m0JWvg8Dyp9+ejGX+Fs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
    gdal
<<<<<<< HEAD
    numpy
    oldest-supported-numpy
    setuptools
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    boto3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hypothesis
    packaging
    pytest-randomly
    pytestCheckHook
    shapely
  ];

<<<<<<< HEAD
  doCheck = true;

  preCheck = ''
    rm -r rasterio # prevent importing local rasterio
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pytestFlagsArray = [
    "-m 'not network'"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_reproject_error_propagation"
  ];

  pythonImportsCheck = [
    "rasterio"
  ];

<<<<<<< HEAD
=======
  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/rio --version | grep ${version} > /dev/null
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    homepage = "https://rasterio.readthedocs.io/";
    changelog = "https://github.com/rasterio/rasterio/blob/${version}/CHANGES.txt";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
