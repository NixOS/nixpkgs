{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools-scm,

  # nativeBuildInputs
  geos,
  proj,

  # dependencies
  matplotlib,
  numpy,
  pyproj,
  pyshp,
  shapely,

  # optional-dependencies
  # ows
  owslib,
  pillow,
  # plotting
  gdal,
  scipy,

  # tests
  fontconfig,
  pytest-mpl,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cartopy";
  version = "0.26.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SciTools";
    repo = "cartopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oOLcCMBKJNfOCqIdjGG0vB/7rJf3mw+t4HZ60RuiXk8=";
  };

  build-system = [
    cython
    setuptools-scm
  ];

  nativeBuildInputs = [
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
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  preCheck = ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

  pytestFlags = [
    "--pyargs"
    "cartopy"
  ];

  disabledTestMarks = [
    "network"
    "natural_earth"
  ];

  meta = {
    description = "Process geospatial data to create maps and perform analyses";
    homepage = "https://scitools.org.uk/cartopy/docs/latest/";
    changelog = "https://github.com/SciTools/cartopy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    teams = [ lib.teams.geospatial ];
    mainProgram = "feature_download";
  };
})
