{
  lib,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  python3Packages,
  qt6,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "veusz";
  version = "4.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = finalAttrs.pname;
    repo = finalAttrs.pname;
    rev = "veusz-${finalAttrs.version}";
    hash = "sha256-gQasdQuXLDDVEELY2ux2URu8888V8CIUwyXBcNnPmPE=";
  };

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = with python3Packages; [
    copyDesktopItems
    sip
    tomli
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  dontUseQmakeConfigure = true;

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];

  # veusz is a script and not an ELF-executable, so wrapQtAppsHook will not wrap
  # it automatically -> we have to do it explicitly
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/veusz"
  '';

  patches = [
    # vectorfield.vsz renders a PPM bitmap whose pixel values differ across Qt versions/platforms
    ./skip-vectorfield-test.patch
    # Remove these after https://github.com/veusz/veusz/pull/830 is merged
    ./sip-pyproject.patch
    ./use-pyvo-samp.patch
  ];

  # pyqt_setuptools.py uses the platlib path from sysconfig, but NixOS doesn't
  # really have a corresponding path, so patching the location of PyQt6 inplace
  postPatch = ''
    substituteInPlace pyqt_setuptools.py \
      --replace-fail "get_path('platlib')" "'${python3Packages.pyqt6}/${python3Packages.python.sitePackages}'"
    patchShebangs tests/runselftest.py
  '';

  postInstall = ''
    install -Dm444 icons/veusz.svg \
      "$out/share/icons/hicolor/scalable/apps/veusz.svg"
    install -Dm444 support/veusz.xml \
      "$out/share/mime/packages/veusz.xml"
    install -Dm444 support/veusz.appdata.xml \
      "$out/share/metainfo/io.github.veusz.Veusz.metainfo.xml"
    substituteInPlace "$out/share/metainfo/io.github.veusz.Veusz.metainfo.xml" \
      --replace-fail '<launchable type="desktop-id">Veusz.desktop</launchable>' \
      '<launchable type="desktop-id">veusz.desktop</launchable>'
  '';

  dependencies = with python3Packages; [
    numpy
    pyqt6
    # optional dependencies
    dbus-python
    h5py
    astropy
    pyvo
    iminuit
    pyemf3
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    wrapQtApp "tests/runselftest.py"
    QT_QPA_PLATFORM=minimal tests/runselftest.py

    runHook postInstallCheck
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Veusz";
      genericName = "Scientific plotting";
      comment = "Scientific plotting and graphing package";
      exec = "veusz %F";
      terminal = false;
      icon = "veusz";
      categories = [
        "DataVisualization"
        "Science"
      ];
      mimeTypes = [ "application/x-veusz" ];
      keywords = [
        "graphing"
        "plotting"
        "graph"
        "plot"
        "visualization"
        "visualisation"
        "science"
        "math"
        "maths"
        "mathematics"
        "data"
      ];
    })
  ];

  meta = {
    description = "Scientific plotting and graphing program with a GUI";
    mainProgram = "veusz";
    homepage = "https://veusz.github.io/";
    changelog = with finalAttrs.src; "https://github.com/${owner}/${repo}/releases/tag/${rev}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ laikq ];
  };
})
