{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  meson-python,
  ninja,
  poppler,
  pkg-config,
  pybind11,
}:

buildPythonPackage rec {
  pname = "python-poppler";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "python_poppler";
    hash = "sha256-5spcI+wCNQvyzvhaa/nxsmF5ZDbbR4F2+dJPsU7uzGo=";
  };

  patches = [
    # Prevent Meson from downloading pybind11, use system version instead
    ./use_system_pybind11.patch
    # Fix build with Poppler 25.01+
    # See: https://github.com/cbrunet/python-poppler/pull/92
    ./poppler-25.patch
  ];

  build-system = [ meson-python ];

  buildInputs = [ pybind11 ];

  nativeBuildInputs = [
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [ poppler ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "poppler" ];

  meta = {
    description = "Python binding to poppler-cpp";
    homepage = "https://github.com/cbrunet/python-poppler";
    changelog = "https://cbrunet.net/python-poppler/changelog.html";
    # Contradictory license definition
    # https://github.com/cbrunet/python-poppler/issues/90
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.onny ];
  };
}
