{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libnest2d,
  sip,
  setuptools,
  wheel,
  clipper,
  pyqt6-sip,
}:

buildPythonPackage (finalAttrs: {
  version = "5.3.0";
  pname = "pynest2d";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "pynest2d";
    tag = finalAttrs.version;
    hash = "sha256-J7QFzWvqOaUx4Gfi5VLLWi0hJIyfYc0Htu2CM7ze6xA=";
  };

  # upstream only ships a conan recipe that generates the pyproject.toml
  postPatch = ''
    cat > pyproject.toml <<'TOML'
    [build-system]
    requires = ["sip >=6, <7", "setuptools>=40.8.0", "wheel"]
    build-backend = "sipbuild.api"

    [project]
    name = "pynest2d"
    version = "${finalAttrs.version}"

    [tool.sip.project]
    sip-files-dir = "python"
    sip-module = "PyQt6.sip"
    abi-version = "13.10"

    [tool.sip.bindings.pynest2d]
    include-dirs = ["${libnest2d}/include", "${lib.getDev clipper}/include/polyclipping"]
    libraries = ["polyclipping", "nlopt"]
    define-macros = ["LIBNEST2D_GEOMETRIES_clipper", "LIBNEST2D_OPTIMIZER_nlopt", "LIBNEST2D_THREADING_std"]
    extra-compile-args = ["-std=c++17"]
    TOML
  '';

  build-system = [
    sip
    setuptools
    wheel
  ];

  dependencies = [ pyqt6-sip ];

  buildInputs = [
    libnest2d
    clipper
  ];

  pythonImportsCheck = [ "pynest2d" ];

  meta = {
    description = "Python bindings for libnest2d";
    homepage = "https://github.com/Ultimaker/pynest2d";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ samirbgno ];
  };
})
