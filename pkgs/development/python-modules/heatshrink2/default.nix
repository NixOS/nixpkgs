{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "heatshrink2";
  version = "0.15.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "pyheatshrink";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-gP2DqFzGdlhQeG4QYHR+2ofVKlYISjLS9dnzg+u77tc=";
  };

  pythonImportsCheck = [ "heatshrink2" ];

  meta = {
    description = "Compression using the Heatshrink algorithm";
    homepage = "https://github.com/eerimoq/pyheatshrink";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
