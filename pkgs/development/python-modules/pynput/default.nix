{ lib, stdenv, buildPythonPackage, fetchPypi, sphinx, setuptools-lint, xlib, evdev }:

buildPythonPackage rec {
  pname = "pynput";
  version = "1.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16fecc4d1e53a28fb7c669c79e189c3f2cde14a08d6b457c3da07075c82f3b4c";
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

