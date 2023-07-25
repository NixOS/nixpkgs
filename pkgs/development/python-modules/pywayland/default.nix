{ lib
, buildPythonPackage
, fetchPypi
, python
, cffi
, pkg-config
, wayland
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pywayland";
  version = "0.4.15";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vz7Sjd8KT7UgOBI5AN5q6CS7jl+WL87w91cgm0bXRGw=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ wayland ];
  propagatedBuildInputs = [ cffi ];
  nativeCheckInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.pythonForBuild.interpreter} pywayland/ffi_build.py
  '';

  # Tests need this to create sockets
  preCheck = ''
    export XDG_RUNTIME_DIR="$PWD"
  '';

  pythonImportsCheck = [ "pywayland" ];

  meta = with lib; {
    homepage = "https://github.com/flacjacket/pywayland";
    description = "Python bindings to wayland using cffi";
    license = licenses.ncsa;
    maintainers = with maintainers; [ chvp ];
  };
}
