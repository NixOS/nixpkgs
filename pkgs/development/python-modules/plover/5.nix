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
}:

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

  # pythonRelaxDeps seemingly doesn't work here
  postPatch = ''
    sed -i 's/,<77//g' pyproject.toml
    sed -i /PySide6-Essentials/d pyproject.toml
  '';

  pythonRelaxDeps = [ "xkbcommon" ];

  build-system = [
    babel
    setuptools
    pyside6
    wheel

    # Replacement for missing pyside6-essentials tools,
    # workaround for https://github.com/NixOS/nixpkgs/issues/277849.
    # Ideally this would be solved in pyside6 itself but I spent four
    # hours trying to untangle its build system before giving up. If
    # anyone wants to spend the time fixing it feel free to request
    # me (@Pandapip1) as a reviewer.
    (buildPackages.writeShellScriptBin "pyside6-uic" ''
      exec ${qtbase}/libexec/uic -g python "$@"
    '')
    (buildPackages.writeShellScriptBin "pyside6-rcc" ''
      exec ${qtbase}/libexec/rcc -g python "$@"
    '')
  ];
  dependencies = [
    appdirs
    evdev
    hidapi
    packaging
    pkginfo
    psutil
    pygments
    pyserial
    pyside6
    plover-stroke
    qtbase
    readme-renderer
    requests-cache
    requests-futures
    rtf-tokenize
    setuptools
    wcwidth
    xkbcommon
    xlib
  ]
  ++ readme-renderer.optional-dependencies.md;
  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
    pytest-qt
    mock
  ];

  # Segfaults?!
  disabledTestPaths = [ "test/gui_qt/test_dictionaries_widget.py" ];

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
    broken = stdenv.hostPlatform.isDarwin;
  };
})
