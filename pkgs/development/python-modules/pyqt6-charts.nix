{ lib
, buildPythonPackage
, fetchPypi
, sip
, pyqt-builder
, qt6Packages
, pythonOlder
, pyqt6
, python
}:

buildPythonPackage rec {
  pname = "PyQt6_Charts";
  version = "6.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FMxuXRnK6AEpUkpC+mMy0NXa2kKCqUI0Jea5rhtrxW0=";
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
  preBuild = ''
    export MAKEFLAGS+="''${enableParallelBuilding:+-j$NIX_BUILD_CORES}"
  '';

  dontWrapQtApps = true;

  nativeBuildInputs = with qt6Packages; [
    qtcharts
    sip
    qmake
    pyqt-builder
  ];

  buildInputs = with qt6Packages; [
    qtcharts
  ];

  propagatedBuildInputs = [
    pyqt6
  ];

  dontConfigure = true;

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "PyQt6.QtCharts"
  ];

  meta = with lib; {
    description = "Python bindings for Qt6 QtCharts";
    homepage = "https://riverbankcomputing.com/";
    license = licenses.gpl3Only;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ dandellion ];
  };
}
