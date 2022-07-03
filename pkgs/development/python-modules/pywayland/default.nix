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
  version = "0.4.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-x075CncvfjzbIsGMj2EwFpigpwlysqBZpoK08DW9iBo=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ wayland ];
  propagatedBuildInputs = [ cffi ];
  checkInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.interpreter} pywayland/ffi_build.py
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
