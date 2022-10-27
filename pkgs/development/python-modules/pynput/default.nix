{ lib, stdenv, buildPythonPackage, fetchPypi, sphinx, setuptools-lint, xlib, evdev }:

buildPythonPackage rec {
  pname = "pynput";
  version = "1.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a5726546da54116b687785d38b1db56997ce1d28e53e8d22fc656d8b92e533c";
  };

  nativeBuildInputs = [ sphinx ];

  propagatedBuildInputs = [ setuptools-lint xlib ]
  ++ lib.optionals stdenv.isLinux [
    evdev
  ];

  doCheck = false;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A library to control and monitor input devices";
    homepage = "https://github.com/moses-palmer/pynput";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nickhu ];
  };
}

