{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pynmeagps,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrtcm";
  version = "1.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "semuconsulting";
    repo = "pyrtcm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hRfz+S4e+qhMP2YvfFDD9MKrTq2QxaNZFxoX0k2divk=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    pynmeagps
  ];

  pythonImportsCheck = [
    "pyrtcm"
  ];

  meta = {
    description = "Python library for parsing RTCM 3 protocol messages";
    homepage = "https://github.com/semuconsulting/pyrtcm";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ luz ];
  };
})
