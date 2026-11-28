{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6,
  ghostscript,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "veusz";
  version = "4.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "veusz";
    repo = "veusz";
    tag = "veusz-${finalAttrs.version}";
    hash = "sha256-gQasdQuXLDDVEELY2ux2URu8888V8CIUwyXBcNnPmPE=";
  };

  build-system = with python3Packages; [
    setuptools
    sip
  ];

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  dontUseQmakeConfigure = true;

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ghostscript ])
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
    # https://github.com/veusz/veusz/pull/830
    ./sip-pyproject.patch
    # https://github.com/veusz/veusz/pull/830
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
    install -Dm644 support/veusz.desktop "$out/share/applications/veusz.desktop"
    install -Dm444 icons/veusz.svg -t "$out/share/icons/hicolor/scalable/apps"
    install -Dm444 support/veusz.xml -t "$out/share/mime/packages"
    install -Dm444 support/veusz.appdata.xml "$out/share/metainfo/io.github.veusz.Veusz.metainfo.xml"
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

  meta = {
    description = "Scientific plotting and graphing program with a GUI";
    mainProgram = "veusz";
    homepage = "https://veusz.github.io/";
    changelog = "https://github.com/veusz/veusz/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ laikq ];
  };
})
