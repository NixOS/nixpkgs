{
  libcec,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

let
  version = "0.2.8";
in
buildPythonPackage {
  pname = "cec";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trainman419";
    repo = "python-cec";
    tag = version;
    hash = "sha256-Y7XjSRT+mxsgTj5IXkOqLNpBMs5alUnJvGQU4yfR3Vw=";
  };

  buildInputs = [
    libcec
  ];

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "cec"
  ];

  meta = {
    description = "Control your TV, reciever and other CEC-compliant HDMI devices from a python script on a computer";
    homepage = "https://github.com/trainman419/python-cec/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jfly ];
  };
}
