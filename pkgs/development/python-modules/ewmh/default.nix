{ lib, buildPythonPackage, fetchFromGitHub, xlib }:

buildPythonPackage rec {
  pname = "ewmh";
  version = "0.1.6";

  src = fetchFromGitHub {
     owner = "parkouss";
     repo = "pyewmh";
     rev = "v0.1.6";
     sha256 = "1hydpyqr5v1qd05aafhahfhpdl0gybfrs5knrgs5pslhygy80qyq";
  };

  propagatedBuildInputs = [ xlib ];

  # No tests included
  doCheck = false;

  meta = {
    homepage = "https://github.com/parkouss/pyewmh";
    description = "An implementation of EWMH (Extended Window Manager Hints), based on Xlib";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ bandresen ];
  };
}
