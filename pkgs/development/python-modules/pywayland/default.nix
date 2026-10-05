{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  cffi,
  pkg-config,
  setuptools,
  wayland,
  wayland-protocols,
  wayland-scanner,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pywayland";
  version = "0.4.19";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nYR49bDfNUAzPM+FpV/os0FQssKMaFgF3p/6hViYVJ4=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    wayland-protocols
    wayland-scanner
  ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ wayland ];
  propagatedBuildInputs = [ cffi ];
  nativeCheckInputs = [ pytestCheckHook ];

  # Tests need this to create sockets
  preCheck = ''
    export XDG_RUNTIME_DIR="$PWD"
  '';

  pythonImportsCheck = [ "pywayland" ];

  meta = {
    homepage = "https://github.com/flacjacket/pywayland";
    description = "Python bindings to wayland using cffi";
    mainProgram = "pywayland-scanner";
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ chvp ];
  };
}
