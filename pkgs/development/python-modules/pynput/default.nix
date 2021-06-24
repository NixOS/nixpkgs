{ lib, stdenv, buildPythonPackage, fetchPypi, sphinx, setuptools-lint, xlib, evdev }:

buildPythonPackage rec {
  pname = "pynput";
  version = "1.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e50b1a0ab86847e87e58f6d1993688b9a44f9f4c88d4712315ea8eb552ef828";
  };

  nativeBuildInputs = [ sphinx ];

  propagatedBuildInputs = [ setuptools-lint xlib ]
  ++ lib.optionals stdenv.isLinux [
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

