{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-time
  qt5,

  # build-system
  setuptools,

  # dependencies
  fastapi,
  guidata,
  numpy,
  packaging,
  pandas,
  plotpy,
  psutil,
  pydantic,
  pywavelets,
  scikit-image,
  scipy,
  sigima,
  uvicorn,

  # optional-dependencies
  babel,
  build,
  coverage,
  pre-commit,
  pylint,
  ruff,
  myst-parser,
  pydata-sphinx-theme,
  sphinx,
  sphinx-copybutton,
  sphinx-design,
  sphinx-intl,
  sphinx-sitemap,
  sphinxcontrib-svg2pdfconverter,
  opencv-python-headless,
  pyinstaller,
  pyqt5,

  # tests
  httpx2,
  pytest,
  pytest-xvfb,
  pytestCheckHook,
  versionCheckHook,
  websockets,

  fullTestSuite ? false,
  datalab-platform, # self
}:

buildPythonPackage (finalAttrs: {
  pname = "datalab-platform";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DataLab-Platform";
    repo = "DataLab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c9ze/Qw6FZ78JEkoQzJSESf/0tWvbL9wHuE2xlzKlv8=";
  };

  # NOTE: DataLab is compatible with qt6, but it's apparently not perfect as
  # the executable segfaults on startup. For now, let's use qt5 which works and
  # migrate in the future.
  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt5.qtwayland
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    fastapi
    guidata
    numpy
    packaging
    pandas
    plotpy
    psutil
    pydantic
    pywavelets
    scikit-image
    scipy
    sigima
    uvicorn
  ]
  ++ uvicorn.optional-dependencies.standard
  ++ finalAttrs.passthru.optional-dependencies.qt
  ++ lib.optionals fullTestSuite [
    # test dependencies - required for bin/datalab-tests
    pytest
    httpx2
    pyyaml
  ];

  optional-dependencies = {
    dev = [
      babel
      build
      coverage
      pre-commit
      pylint
      ruff
    ];
    doc = [
      myst-parser
      pydata-sphinx-theme
      sphinx
      sphinx-copybutton
      sphinx-design
      sphinx-intl
      sphinx-sitemap
      sphinxcontrib-svg2pdfconverter
    ];
    exe = [
      opencv-python-headless
      pyinstaller
      pyqt5
    ];
    opencv = [
      opencv-python-headless
    ];
    qt = [
      pyqt5
    ];
  };

  pythonRelaxDeps = [
    "guidata"
    "numpy"
    "plotpy"
    "scipy"
  ];

  pythonImportsCheck = [
    "datalab"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];


  nativeCheckInputs = [
    httpx2
    pytestCheckHook
  ]
  ++ lib.optionals fullTestSuite [
    pytest-xvfb
    ruff
    websockets
  ];

  # running the full test suite takes ~20 minutes, moved to passthru.tests
  pytestFlags = lib.optionals (!fullTestSuite) [
    "--collect-only"
  ];

  passthru.tests.full = datalab-platform.override { fullTestSuite = true; };

  postInstall = lib.optionalString (!fullTestSuite) ''
    rm $out/bin/datalab-tests
  '';

  dontWrapQtApps = true;

  preFixup = ''
    # Python scripts need to be manually wrapped
    for exe in "$out/bin"/datalab*; do
      wrapQtApp "$exe"
    done
  '';

  meta = {
    description = "Open-source Platform for Scientific and Technical Data Processing and Visualization";
    homepage = "https://github.com/DataLab-Platform/DataLab";
    changelog = "https://github.com/DataLab-Platform/DataLab/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "datalab";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
