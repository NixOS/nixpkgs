{
  lib,
  stdenv,
  buildPackages,
  buildPythonPackage,
  fetchFromGitHub,
  versionCheckHook,
  appdirs,
  babel,
  evdev,
  mock,
  packaging,
  pkginfo,
  psutil,
  pygments,
  pyserial,
  pyside6,
  pytestCheckHook,
  pytest-qt,
  plover-stroke,
  readme-renderer,
  requests-cache,
  requests-futures,
  rtf-tokenize,
  setuptools,
  wcwidth,
  wheel,
  xlib,
  qtbase,
  wrapQtAppsHook,
  hidapi,
  xkbcommon,
  pyobjc-framework-Quartz,
  pyobjc-framework-Cocoa,
  appnope,
  pyobjc-core,
}:

let
  # Replacement for missing pyside6-essentials tools,
  # workaround for https://github.com/NixOS/nixpkgs/issues/277849.
  # Ideally this would be solved in pyside6 itself but I spent four
  # hours trying to untangle its build system before giving up. If
  # anyone wants to spend the time fixing it feel free to request
  # me (@Pandapip1) as a reviewer.
  pyside-tools-rcc = buildPackages.writeShellScriptBin "pyside6-rcc" ''
    exec ${buildPackages.qt6.qtbase}/libexec/rcc -g python "$@"
  '';
  pyside-tools-uic = buildPackages.writeShellScriptBin "pyside6-uic" ''
    exec ${buildPackages.qt6.qtbase}/libexec/uic -g python "$@"
  '';
in
buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "plover";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "plover";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1NpZmUDq806geKANqswPYglHwInxum/c/Hxq7JhTpbc=";
  };

  postPatch = ''
    # pythonRelaxDeps doesn't work for build-system dependencies
    sed -i 's/,<77//g' pyproject.toml

    substituteInPlace plover_build_utils/setup.py \
      --replace-fail "pyside6-rcc" ${lib.getExe pyside-tools-rcc} \
      --replace-fail "pyside6-uic" ${lib.getExe pyside-tools-uic}
  '';

  pythonRelaxDeps = [
    "xkbcommon"
  ];

  pythonRemoveDeps = [
    # We currently don't have it in Nixpkgs.
    "PySide6-Essentials"
  ];

  build-system = [
    babel
    setuptools
    pyside6
    wheel
  ];
  dependencies = [
    appdirs
    hidapi
    packaging
    pkginfo
    psutil
    pygments
    pyserial
    pyside6
    plover-stroke
    readme-renderer
    requests-cache
    requests-futures
    rtf-tokenize
    setuptools
    wcwidth
    xkbcommon
    xlib
  ]
  ++ readme-renderer.optional-dependencies.md
  ++ lib.optionals stdenv.hostPlatform.isLinux [ evdev ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    appnope
    pyobjc-core
    pyobjc-framework-Cocoa
    pyobjc-framework-Quartz
  ];
  optional-dependencies = {
    gui-qt = [
      # TODO(@ShamrockLee): use PySide6-Essentials once available
      pyside6
    ];
  };
  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
    pytest-qt
    mock
  ];

  disabledTestPaths = [
    "test/gui_qt/test_dictionaries_widget.py" # segfaults
    "test/gui_qt/test_i18n_files.py" # babel errors
  ];

  postInstall = ''
    install -Dm 444 linux/plover.desktop $out/share/applications/plover.desktop
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  dontWrapQtApps = true;

  pythonImportsCheck = [ "plover" ];

  meta = {
    description = "OpenSteno Plover stenography software";
    homepage = "https://www.openstenoproject.org/plover/";
    mainProgram = "plover";
    maintainers = with lib.maintainers; [
      twey
      kovirobi
      pandapip1
      ShamrockLee
    ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
