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
, xorg
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pywlroots";
  version = "0.15.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "EJAqtzFKx9Zripspv3lXIDj54pqHV0in6RrOCgFUyU8=";
  };

  # The XWayland detection uses some hard-coded FHS paths. Since we
  # know wlroots was built with xwayland support, replace its
  # detection with `return True`.
  patches = [ ./xwayland.patch ];

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ libinput libxkbcommon pixman xorg.libxcb udev wayland wlroots ];
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ chvp ];
  };
}
