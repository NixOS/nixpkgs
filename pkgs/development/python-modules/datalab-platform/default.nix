{
  lib,
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
  httpx,
  pytest,
  pytest-xvfb,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "datalab-platform";
  version = "1.2.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DataLab-Platform";
    repo = "DataLab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rJDA5qYv2LYMyrckxNy63Gqn8HYU62qG0OAioztKGtA=";
  };

  # NOTE: DataLab is compatible with qt6, but it's apparently not perfect as
  # the executable segfaults on startup. For now, let's use qt5 which works and
  # migrate in the future.
  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
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
  ++ finalAttrs.passthru.optional-dependencies.qt
  # required for `bin/datalab-{demo,tests}`
  ++ finalAttrs.passthru.optional-dependencies.test;

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
    test = [
      httpx
      pytest
      pytest-xvfb
    ];
  };

  pythonRelaxDeps = [
    "guidata"
    "plotpy"
    "scipy"
  ];

  pythonImportsCheck = [
    "datalab"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.test;

  pytestFlags = [
    "--collect-only"
  ];

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
