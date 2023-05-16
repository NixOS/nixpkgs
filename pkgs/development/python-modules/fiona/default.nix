{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cython
, gdal
, setuptools
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, attrs
, certifi
, click
, click-plugins
, cligj
, munch
, shapely
, boto3
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "fiona";
<<<<<<< HEAD
  version = "1.9.4.post1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

=======
  version = "1.9.1";

  disabled = pythonOlder "3.7";

  format = "pyproject";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "Toblerity";
    repo = "Fiona";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-CeGdWAmWteVtL0BoBQ1sB/+1AWkmxogtK99bL5Fpdbw=";
  };

  postPatch = ''
    # Remove after https://github.com/Toblerity/Fiona/pull/1225 is released
    sed -i '/"oldest-supported-numpy"/d' pyproject.toml

    # Remove after https://github.com/Toblerity/Fiona/pull/1281 is released,
    # after which cython also needs to be updated to cython_3
    sed -i 's/Cython~=/Cython>=/' pyproject.toml
  '';

=======
    hash = "sha256-2CGLkgnpCAh9G+ILol5tmRj9S6/XeKk8eLzGEODiyP8=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    cython
    gdal # for gdal-config
    setuptools
<<<<<<< HEAD
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    gdal
  ];

  propagatedBuildInputs = [
    attrs
    certifi
    click
    cligj
    click-plugins
    munch
<<<<<<< HEAD
=======
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  passthru.optional-dependencies = {
    calc = [ shapely ];
    s3 = [ boto3 ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ] ++ passthru.optional-dependencies.s3;

  preCheck = ''
    rm -r fiona # prevent importing local fiona
  '';

<<<<<<< HEAD
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

  pythonImportsCheck = [
    "fiona"
  ];

  doInstallCheck = true;
=======
  disabledTests = [
    # Some tests access network, others test packaging
    "http" "https" "wheel"
  ];

  pythonImportsCheck = [ "fiona" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    changelog = "https://github.com/Toblerity/Fiona/blob/${src.rev}/CHANGES.txt";
    description = "OGR's neat, nimble, no-nonsense API for Python";
    homepage = "https://fiona.readthedocs.io/";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = teams.geospatial.members;
=======
    maintainers = with maintainers; [ knedlsepp ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
