{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, cython
, setuptools-scm
, geos
, proj
, matplotlib
, numpy
, pyproj
, pyshp
, shapely
, owslib
, pillow
, gdal
, scipy
, fontconfig
, pytest-mpl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cartopy";
<<<<<<< HEAD
  version = "0.22.0";
=======
  version = "0.21.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "Cartopy";
<<<<<<< HEAD
    hash = "sha256-swD5ASCTHUPxHvh8Bk6h2s7BtZpJQKp26/gs8JVIu0k=";
  };

=======
    hash = "sha256-idVklxLIWCIxxuEYJaBMhfbwzulNu4nk2yPqvKHMJQo=";
  };

  patches = [
    # https://github.com/SciTools/cartopy/pull/2163
    (fetchpatch {
      url = "https://github.com/SciTools/cartopy/commit/7fb57e294914dbda0ebe8caaeac4deffe5e71639.patch";
      hash = "sha256-qc14q+v2IMC+1NQ+OqLjUfJA3Sr5txniqS7CTQ6c7LI=";
    })
    # https://github.com/SciTools/cartopy/pull/2130
    (fetchpatch {
      url = "https://github.com/SciTools/cartopy/commit/6b4572ba1a8a877f28e25dfe9559c14b7a565958.patch";
      hash = "sha256-0u6VJMrvoD9bRLHiQV4HQCKDyWEb9dDS2A3rjm6uqYw=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    cython
    geos # for geos-config
    proj
    setuptools-scm
  ];

  buildInputs = [
<<<<<<< HEAD
    geos
    proj
=======
    geos proj
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pyproj
    pyshp
    shapely
  ];

  passthru.optional-dependencies = {
    ows = [ owslib pillow ];
    plotting = [ gdal pillow scipy ];
  };

  nativeCheckInputs = [
    pytest-mpl
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  preCheck = ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
    export HOME=$TMPDIR
  '';

  pytestFlagsArray = [
<<<<<<< HEAD
    "--pyargs"
    "cartopy"
    "-m"
    "'not network and not natural_earth'"
=======
    "--pyargs" "cartopy"
    "-m" "'not network and not natural_earth'"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTests = [
    "test_gridliner_labels_bbox_style"
  ];

  meta = with lib; {
    description = "Process geospatial data to create maps and perform analyses";
    license = licenses.lgpl3Plus;
    homepage = "https://scitools.org.uk/cartopy/docs/latest/";
    maintainers = with maintainers; [ mredaelli ];
  };
}
