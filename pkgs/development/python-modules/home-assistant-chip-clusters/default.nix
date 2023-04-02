{ lib
, buildPythonPackage
, fetchPypi
, dacite
}:

buildPythonPackage rec {
  pname = "home-assistant-chip-clusters";
  version = "2023.2.2";
  format = "wheel";

  src = fetchPypi {
    inherit format version;
    pname = "home_assistant_chip_clusters";
    dist = "py3";
    python = "py3";
    hash = "sha256-FsIE4dcZOP24/DX6TLnmoCHMYe4f9gWqmv2L25ujqu4=";
  };

  propagatedBuildInputs = [
    dacite
  ];

  pythonImportsCheck = [
    "chip.clusters"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Python-base APIs and tools for CHIP";
    homepage = "https://github.com/home-assistant-libs/chip-wheels";
    changelog = "https://github.com/home-assistant-libs/chip-wheels/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
