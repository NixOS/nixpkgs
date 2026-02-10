{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "heatshrink2";
  version = "0.13.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "pyheatshrink";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-gspMd3Fyxe2/GhZYdKjVcZXRlslay3jO4jZuVG79G44=";
  };

  pythonImportsCheck = [ "heatshrink2" ];

  meta = {
    description = "Compression using the Heatshrink algorithm";
    homepage = "https://github.com/eerimoq/pyheatshrink";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
