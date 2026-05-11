{
  lib,
  python3Packages,
  fetchPypi,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "yakut";
  version = "0.14.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z/lzUZwUKQne0iGRPvXiATPgegoSbNE4GBgU+i6H5q0=";
  };

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
  ];
  dependencies = [
    python3Packages.click
    python3Packages.coloredlogs
    python3Packages.psutil
    python3Packages.pycyphal
    python3Packages.ruamel-yaml
    python3Packages.requests
    python3Packages.scipy
    python3Packages.simplejson
  ];
  optional-dependencies.joystick = [
    python3Packages.pysdl2
    python3Packages.mido
    python3Packages.python-rtmidi
  ];

  # All these require extra permissions and/or actual hardware connected
  doCheck = false;

  meta = {
    description = "Simple CLI tool for diagnostics and debugging of Cyphal networks";
    longDescription = ''
      Yakút is a simple cross-platform command-line interface (CLI) tool for diagnostics and debugging of Cyphal networks. By virtue of being based on PyCyphal, Yakut supports all Cyphal transports (UDP, serial, CAN, ...) and is compatible with all major features of the protocol. It is designed to be usable with GNU/Linux, Windows, and macOS.
    '';
    homepage = "https://github.com/OpenCyphal/yakut/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kip93 ];
  };
}
