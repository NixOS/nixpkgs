{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  cffi,
  pkg-config,
  libxkbcommon,
  libinput,
  pixman,
  udev,
  wlroots,
  wayland,
  pywayland,
  xkbcommon,
  pytestCheckHook,
  qtile,
}:

buildPythonPackage rec {
  pname = "pywlroots";
  version = "0.17.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cssr4UBIwMvInM8bV4YwE6mXf9USSMMAzMcgAefEPbs=";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [
    libinput
    libxkbcommon
    pixman
    udev
    wayland
    wlroots
  ];
  propagatedBuildInputs = [
    cffi
    pywayland
    xkbcommon
  ];
  nativeCheckInputs = [ pytestCheckHook ];

  postBuild = ''
    ${python.pythonOnBuildForHost.interpreter} wlroots/ffi_build.py
  '';

  pythonImportsCheck = [ "wlroots" ];

  passthru.tests = {
    inherit qtile;
  };

  meta = {
    homepage = "https://github.com/flacjacket/pywlroots";
    description = "Python bindings to wlroots using cffi";
    license = lib.licenses.ncsa;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      chvp
      doronbehar
    ];
  };
}
