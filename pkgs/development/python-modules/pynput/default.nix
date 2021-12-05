{ lib, stdenv, buildPythonPackage, fetchPypi, sphinx, setuptools-lint, xlib
, evdev }:

buildPythonPackage rec {
  pname = "pynput";
  version = "1.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e6b7926dd162a883ff16f38e01720a930bbf2509146c9f1cdcecddd25288fb6e";
  };

  nativeBuildInputs = [ sphinx ];

  propagatedBuildInputs = [ setuptools-lint xlib ]
    ++ lib.optionals stdenv.isLinux [ evdev ];

  doCheck = false;

  meta = with lib; {
    description = "A library to control and monitor input devices";
    homepage = "https://github.com/moses-palmer/pynput";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nickhu ];
  };
}

