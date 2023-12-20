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
  version = "0.4.17";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9/0ZAmOML3oVrAfzGj72iV08FgyiYBSByoKyxhojxlc=";
  };

  nativeBuildInputs = [ pkg-config ];
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

  meta = with lib; {
    homepage = "https://github.com/flacjacket/pywayland";
    description = "Python bindings to wayland using cffi";
    license = licenses.ncsa;
    maintainers = with maintainers; [ chvp ];
  };
}
