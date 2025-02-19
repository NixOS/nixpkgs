{
  lib,
  buildPythonPackage,
  cython,
  fetchpatch,
  fetchPypi,
  fontconfig,
  gdal,
  geos,
  matplotlib,
  numpy,
  owslib,
  pillow,
  proj,
  pyproj,
  pyshp,
  pytest-mpl,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools-scm,
  shapely,
}:

buildPythonPackage rec {
  pname = "cartopy";
  version = "0.24.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AckQ1WNMaafv3sRuChfUc9Iyh2fwAdTcC1xLSOWFyL0=";
  };

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [
    cython
    geos # for geos-config
    proj
  ];

  buildInputs = [
    geos
    proj
  ];

  dependencies = [
    matplotlib
    numpy
    pyproj
    pyshp
    shapely
  ];

  optional-dependencies = {
    ows = [
      owslib
      pillow
    ];
    plotting = [
      gdal
      pillow
      scipy
    ];
  };

  nativeCheckInputs = [
    pytest-mpl
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
    "test_gridliner_constrained_adjust_datalim"
    "test_gridliner_labels_bbox_style"
  ];

  meta = with lib; {
    description = "Process geospatial data to create maps and perform analyses";
    homepage = "https://scitools.org.uk/cartopy/docs/latest/";
    changelog = "https://github.com/SciTools/cartopy/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
    mainProgram = "feature_download";
  };
}
