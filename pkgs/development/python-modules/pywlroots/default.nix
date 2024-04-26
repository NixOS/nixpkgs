{ lib
, buildPythonPackage
, fetchPypi
, python
, cffi
, pkg-config
, libxkbcommon
, libinput
, pixman
, pythonOlder
, udev
, wlroots
, wayland
, pywayland
, xkbcommon
, xorg
, pytestCheckHook
, qtile
}:

buildPythonPackage rec {
  pname = "pywlroots";
  version = "0.16.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zfjcXQCXysG+JMw00YES/GQk/yjHH9kCksb9SlZt9wo=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ libinput libxkbcommon pixman xorg.libxcb xorg.xcbutilwm udev wayland wlroots ];
  propagatedBuildInputs = [ cffi pywayland xkbcommon ];
  nativeCheckInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.pythonOnBuildForHost.interpreter} wlroots/ffi_build.py
  '';

  pythonImportsCheck = [ "wlroots" ];

  passthru.tests = { inherit qtile; };

  meta = with lib; {
    homepage = "https://github.com/flacjacket/pywlroots";
    description = "Python bindings to wlroots using cffi";
    license = licenses.ncsa;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chvp ];
  };
}
