{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "heatshrink2";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "pyheatshrink";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-JthHYq78SYr49+sTNtLZ8GjtrHcr1dzXcPskTrb4M3o=";
  };

  pythonImportsCheck = [ "heatshrink2" ];

  meta = with lib; {
    description = "Compression using the Heatshrink algorithm";
    homepage = "https://github.com/eerimoq/pyheatshrink";
    license = licenses.isc;
    maintainers = with maintainers; [ prusnak ];
  };
}
