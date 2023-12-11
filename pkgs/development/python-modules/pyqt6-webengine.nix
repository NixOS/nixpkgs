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
, python
}:

buildPythonPackage rec {
  pname = "PyQt6_WebEngine";
  version = "6.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1QuYTD+F5AnmkrFWEychUi1OjPm2wl4M+Sfuot+zlIc=";
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
  '';

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  nativeBuildInputs = with qt6Packages; [
    pkg-config
    lndir
    sip
    qtwebengine
    qmake
    pyqt-builder
  ];

  buildInputs = with qt6Packages; [
    qtwebengine
  ];

  propagatedBuildInputs = [
    pyqt6
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
