{
  lib,
  buildPythonPackage,
  fetchPypi,
  xlib,
}:

buildPythonPackage rec {
  pname = "ewmh";
  version = "0.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xWsJP31XUYHpebs6fRXDQGV1X4EcNR/wox/t4SsJND0=";
  };

  propagatedBuildInputs = [ xlib ];

  # No tests included
  doCheck = false;

  meta = {
    homepage = "https://github.com/parkouss/pyewmh";
    description = "Implementation of EWMH (Extended Window Manager Hints), based on Xlib";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ bandresen ];
  };
}
