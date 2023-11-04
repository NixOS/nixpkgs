{ lib
, buildPythonPackage
, fetchPypi
, pkg-config
, lndir
, sip
, pyqt-builder
, qt6Packages
, pythonOlder
, pyqt6
, pyqt6-sip
, setuptools
, python
, pkgsHostTarget
, pkgsBuildTarget
, buildPackages
}:

buildPythonPackage rec {
  pname = "PyQt6_WebEngine";
  version = "6.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i6nbVsTBgaKi+rFnPKNeW2PcaRE/CFAn3cQ8cQttbuk=";
  };

  # fix include path and increase verbosity
  postPatch = ''
    sed -i \
      '/\[tool.sip.project\]/a\
      verbose = true\
      sip-include-dirs = [\"${pyqt6}/${python.sitePackages}/PyQt6/bindings\"]' \
      pyproject.toml
  '';

  enableParallelBuilding = true;
  # HACK: paralellize compilation of make calls within pyqt's setup.py
  # pkgs/stdenv/generic/setup.sh doesn't set this for us because
  # make gets called by python code and not its build phase
  # format=pyproject means the pip-build-hook hook gets used to build this project
  # pkgs/development/interpreters/python/hooks/pip-build-hook.sh
  # does not use the enableParallelBuilding flag
  postUnpack = ''
    export MAKEFLAGS+=" -j$NIX_BUILD_CORES"
    export QT_ADDITIONAL_PACKAGES_PREFIX_PATH+="${qt6Packages.qtwebengine.dev}:${qt6Packages.qtwebengine}"
    export QMAKEPATH+="${qt6Packages.qtwebengine.dev}:${qt6Packages.qtwebengine}"
  '';

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    pkg-config
    lndir
    buildPackages.python3Packages.sip
    pkgsHostTarget.qt6Packages.qtbase
    pkgsHostTarget.qt6Packages.qmake
    qt6Packages.qtbase
    qt6Packages.qmake
  ];

  buildInputs = with qt6Packages; [
    qtbase
    qmake
    qtdeclarative
    qtwebengine
    qtwebengine.dev
    pyqt6
    pyqt6-sip
    pyqt-builder
  ];

  propagatedBuildInputs = [
    qt6Packages.qtbase
    setuptools
  ];

  passthru = {
    inherit sip;
  };

  dontConfigure = true;

  # Checked using pythonImportsCheck, has no tests
  doCheck = true;

  pythonImportsCheck = [
    "PyQt6.QtWebEngineCore"
    "PyQt6.QtWebEngineQuick"
    "PyQt6.QtWebEngineWidgets"
  ];

  meta = with lib; {
    description = "Python bindings for Qt6 WebEngine";
    homepage = "https://riverbankcomputing.com/";
    license = licenses.gpl3Only;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ LunNova nrdxp ];
  };
}
