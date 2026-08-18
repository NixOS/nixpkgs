{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "heatshrink2";
  version = "0.14.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "pyheatshrink";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-2bCk9bS/6hjbBJ30fpTt750A3vAvq4HOXmbpxOLRuj4=";
  };

  pythonImportsCheck = [ "heatshrink2" ];

  meta = {
    description = "Compression using the Heatshrink algorithm";
    homepage = "https://github.com/eerimoq/pyheatshrink";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
