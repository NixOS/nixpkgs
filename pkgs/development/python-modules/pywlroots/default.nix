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
  version = "0.16.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W43RCJektumgvO9K3K3mHR1BiyZXsHj4fN2EkGlJChQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ libinput libxkbcommon pixman xorg.libxcb xorg.xcbutilwm udev wayland wlroots ];
  propagatedBuildInputs = [ cffi pywayland xkbcommon ];
  nativeCheckInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.pythonForBuild.interpreter} wlroots/ffi_build.py
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
