{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  cffi,
  pkg-config,
  wayland,
  wayland-scanner,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pywayland";
  version = "0.4.18";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WYreAng6rQWjKPZjtRtpTFq2i9XR4JJsDaPFISxWZTM=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ wayland-scanner ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ wayland ];
  propagatedBuildInputs = [ cffi ];
  nativeCheckInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.pythonOnBuildForHost.interpreter} pywayland/ffi_build.py
  '';

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
