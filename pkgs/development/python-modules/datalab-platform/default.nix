{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-time
  qt6,

  # build-system
  setuptools,

  # dependencies
  datalab-capsule,
  fastapi,
  guidata,
  jedi,
  numpy,
  packaging,
  pandas,
  pip,
  plotpy,
  psutil,
  pydantic,
  pywavelets,
  scikit-image,
  scipy,
  sigima,
  sigimax,
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
  sphinxext-opengraph,
  opencv-python-headless,
  pyinstaller,
  pyqt6,

  # tests
  httpx2,
  pytest,
  pytest-xvfb,
  pytestCheckHook,
  pyyaml,
  versionCheckHook,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "datalab-platform";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DataLab-Platform";
    repo = "DataLab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wTKo59eat2ZPtmfCf+gLW+4UA602Cn4iqshmlFGY+K8=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    datalab-capsule
    fastapi
    guidata
    jedi
    numpy
    packaging
    pandas
    pip
    plotpy
    psutil
    pydantic
    pywavelets
    scikit-image
    scipy
    sigima
    sigimax
    uvicorn

    # test dependencies - required for bin/datalab-tests
    pytest
    httpx2
    pyyaml
  ]
  ++ finalAttrs.passthru.optional-dependencies.qt;

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
      sphinxext-opengraph
    ];
    exe = [
      opencv-python-headless
      pyinstaller
      pyqt6
    ];
    opencv = [
      opencv-python-headless
    ];
    qt = [
      pyqt6
    ];
  };

  pythonImportsCheck = [
    "datalab"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  preCheck = ''
    export QT_PLUGIN_PATH="${lib.getBin qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}:${qt6.qtsvg}/${qt6.qtbase.qtPluginPrefix}"
  '';

  nativeCheckInputs = [
    httpx2
    pytest-xvfb
    pytestCheckHook
    pyyaml
    ruff
    websockets
  ];

  disabledTests = [
    # Requires recursive resolution of all optional uvicorn distributions
    "test_generated_and_unversioned_modules_need_no_packaging"
    "test_module_prepare_never_invokes_pip"
  ];

  # full test suite takes ~20 minutes, moved to passthru.tests
  pytestFlags = [
    "--collect-only"
  ];

  passthru.tests.full = finalAttrs.finalPackage.overrideAttrs {
    pytestFlags = [ ];
  };

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
