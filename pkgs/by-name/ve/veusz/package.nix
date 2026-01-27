{
  lib,
  python3Packages,
  fetchPypi,
  qt6,
}:

python3Packages.buildPythonApplication rec {
  pname = "veusz";
  version = "4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jyghPk/u4THHnXrG/UDzHfW4AkS6n0CEd3VK+GX9he0=";
  };

  nativeBuildInputs = [
    python3Packages.sip
    python3Packages.tomli
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  dontUseQmakeConfigure = true;

  buildInputs = [ qt6.qtbase ];

  # veusz is a script and not an ELF-executable, so wrapQtAppsHook will not wrap
  # it automatically -> we have to do it explicitly
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/veusz"
  '';

  # pyqt_setuptools.py uses the platlib path from sysconfig, but NixOS doesn't
  # really have a corresponding path, so patching the location of PyQt5 inplace
  postPatch = ''
    substituteInPlace pyqt_setuptools.py \
      --replace-fail "get_path('platlib')" "'${python3Packages.pyqt5}/${python3Packages.python.sitePackages}'"
    patchShebangs tests/runselftest.py
  '';

  # you can find these options at
  # https://github.com/veusz/veusz/blob/53b99dffa999f2bc41fdc5335d7797ae857c761f/pyqtdistutils.py#L71
  setupPyBuildFlags = [
    # veusz tries to find a libinfix and fails without one
    # but we simply don't need a libinfix, so set it to empty here
    "--qt-libinfix="
  ];

  dependencies = with python3Packages; [
    numpy
    pyqt6
    # optional requirements:
    dbus-python
    h5py
    # astropy -- fails to build on master
    # optional TODO: add iminuit, pyemf and sampy
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
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ laikq ];
  };
}
