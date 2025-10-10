{
  lib,
  buildPythonPackage,
  cython,
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
  version = "0.25.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VfGjkOXz8HWyIcfZH7ECWK2XjbeGx5MOugbrRdKHU/4=";
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
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
    export HOME=$TMPDIR
  '';

  pytestFlags = [
    "--pyargs"
    "cartopy"
  ];

  disabledTestMarks = [
    "network"
    "natural_earth"
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
    maintainers = [ ];
    mainProgram = "feature_download";
  };
}
