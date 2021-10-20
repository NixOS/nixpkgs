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
  version = "0.14.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "jzHh5ubonn6pCaOp+Dnr7tA9n5DdZ28hBM+03jZZlvc=";
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
