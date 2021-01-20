{ lib, stdenv, buildPythonPackage, fetchPypi, sphinx, setuptools-lint, xlib, evdev }:

buildPythonPackage rec {
  pname = "pynput";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a5598bfb14322eff980ac6ca820635fce9028faa4f64a8e1581243aaf6785ee";
  };

  nativeBuildInputs = [ sphinx ];

  propagatedBuildInputs = [ setuptools-lint xlib ]
  ++ stdenv.lib.optionals stdenv.isLinux [
    evdev
  ];

  doCheck = false;

  meta = with lib; {
    description = "A library to control and monitor input devices";
    homepage = "https://github.com/moses-palmer/pynput";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nickhu ];
  };
}

