{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  stdenv,
  # build-system
  flit-core,
  # dependencies
  attrs,
  numpy,
  pyquaternion,
  colour,
  rich,
  moderngl,
  pyopengl,
  tqdm,
  psutil,
  skia-pathops,
  fonttools,
  freetype-py,
  pillow,
  svgelements,
  typst,
  # optional-dependencies (gui)
  enableGui ? true,
  pyside6,
  qdarkstyle,
  beautifulsoup4,
  sounddevice,
  wrapQtAppsHook,
  qtbase,
  # optional-dependencies (test)
  opencv4,
  coverage,
  # tests
  pytestCheckHook,
  # runtime
  ffmpeg,
}:
buildPythonPackage (finalAttrs: {
  pname = "janim";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "jkjkil4";
    repo = "JAnim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QUsuy2oFNqmRDVjJew8OxYZny3/qBJHfmBG8SCjOPkM=";
  };

  build-system = [
    flit-core
  ];

  dependencies =
    [
      attrs
      numpy
      pyquaternion
      colour
      rich
      moderngl
      pyopengl
      tqdm
      psutil
      skia-pathops
      fonttools
      freetype-py
      pillow
      svgelements
      typst
    ]
    ++ lib.optionals enableGui ([
        pyside6
        qdarkstyle
        beautifulsoup4
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        sounddevice
      ]);

  # PySide6 pulls in Qt6 libraries that need plugin paths (platforms,
  # imageformats, etc.) set via environment variables.  wrapQtAppsHook
  # normally does this by wrapping every executable it finds, but
  # buildPythonPackage already wraps scripts with its own Python-aware
  # wrapper.  Two competing wrappers cause double-wrapping and broken
  # shebangs.  Setting dontWrapQtApps = true disables the automatic Qt
  # wrapping and instead we forward the qtWrapperArgs (which contain
  # QT_PLUGIN_PATH, QML2_IMPORT_PATH, XDG_DATA_DIRS, etc.) into the
  # Python makeWrapper call via makeWrapperArgs.
  nativeBuildInputs = lib.optionals enableGui [
    wrapQtAppsHook
  ];
  buildInputs = lib.optionals enableGui [
    qtbase
  ];

  dontWrapQtApps = true;

  optional-dependencies = {
    gui =
      [
        pyside6
        qdarkstyle
        beautifulsoup4
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        sounddevice
      ];
    test = [
      opencv4
      coverage
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = true;
  pytestFlagsArray = [
    "test/utils"
    "test/component"
    "test/items"
    "test/anims"
    # test/examples excluded: needs pre-generated reference PNGs and an OpenGL context
  ];

  preCheck = ''
    cat > conftest.py << 'EOF'
    import unittest.mock
    import psutil
    # psutil.sensors_battery() reads /sys/class/power_supply which is
    # unavailable in the Nix sandbox; patch it before janim.utils.config loads
    psutil.sensors_battery = unittest.mock.Mock(return_value=None)
    EOF
  '';

  pythonImportsCheck = ["janim"];

  makeWrapperArgs =
    [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [ffmpeg])
    ]
    ++ lib.optionals enableGui [
      # Splice in the Qt wrapper arguments so that the single Python
      # wrapper also carries the QT_PLUGIN_PATH and friends that Qt
      # needs at runtime.
      "\${qtWrapperArgs[@]}"
    ];

  meta = {
    description = "Programmatic animation engine for creating precise and smooth animations with real-time feedback";
    longDescription = ''
      JAnim is a programmatic animation engine for creating precise and smooth
      animations.  It supports real-time editing, live preview, and a wide range
      of other rich features.  Inspired by manim (3Blue1Brown's animation engine).
    '';
    homepage = "https://github.com/jkjkil4/JAnim";
    documentation = "https://janim.rtfd.io";
    changelog = "https://github.com/jkjkil4/JAnim/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      instable
    ];
    mainProgram = "janim";
  };
})
