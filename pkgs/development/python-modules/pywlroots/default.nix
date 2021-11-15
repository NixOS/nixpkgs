{ lib
, buildPythonPackage
, fetchPypi
, python
, cffi
, pkg-config
, libxkbcommon
, libinput
, pixman
, udev
, wlroots
, wayland
, pywayland
, xkbcommon
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pywlroots";
  version = "0.14.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c3bf811d60adb612d9ee7dc5aec9ada3947bf7ec93c3252e7b9cd32582191f8";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ libinput libxkbcommon pixman udev wayland wlroots ];
  propagatedBuildInputs = [ cffi pywayland xkbcommon ];
  checkInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.interpreter} wlroots/ffi_build.py
  '';

  pythonImportsCheck = [ "wlroots" ];

  meta = with lib; {
    homepage = "https://github.com/flacjacket/pywlroots";
    description = "Python bindings to wlroots using cffi";
    license = licenses.ncsa;
    maintainers = with maintainers; [ chvp ];
  };
}
