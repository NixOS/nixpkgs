{ buildPythonPackage
, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "heatshrink2";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "pyheatshrink";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-P3IofGbW4x+erGCyxIPvD9aNHIJ/GjjWgno4n95SQoQ=";
  };

  pythonImportsCheck = [ "heatshrink2" ];

  meta = with lib; {
    description = "Compression using the Heatshrink algorithm in Python 3.";
    homepage = "https://github.com/eerimoq/pyheatshrink";
    license = licenses.isc;
    maintainers = with maintainers; [ prusnak ];
  };
}
