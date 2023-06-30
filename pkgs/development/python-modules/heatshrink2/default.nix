{ buildPythonPackage
, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "heatshrink2";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "pyheatshrink";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-JthHYq78SYr49+sTNtLZ8GjtrHcr1dzXcPskTrb4M3o=";
  };

  pythonImportsCheck = [ "heatshrink2" ];

  meta = with lib; {
    description = "Compression using the Heatshrink algorithm in Python 3.";
    homepage = "https://github.com/eerimoq/pyheatshrink";
    license = licenses.isc;
    maintainers = with maintainers; [ prusnak ];
  };
}
