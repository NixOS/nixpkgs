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
  version = "0.23.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "Cartopy";
    hash = "sha256-Ix83s1cB8rox2UlZzKdebaBMLuo6fxTOHHXuOw6udnY=";
  };

  nativeBuildInputs = [
    cython
    geos # for geos-config
    proj
    setuptools-scm
  ];

  buildInputs = [
    geos
    proj
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
    "--pyargs"
    "cartopy"
    "-m"
    "'not network and not natural_earth'"
  ];

  disabledTests = [
    "test_gridliner_labels_bbox_style"
  ];

  meta = with lib; {
    description = "Process geospatial data to create maps and perform analyses";
    mainProgram = "feature_download";
    license = licenses.lgpl3Plus;
    homepage = "https://scitools.org.uk/cartopy/docs/latest/";
    maintainers = with maintainers; [ mredaelli ];
  };
}
