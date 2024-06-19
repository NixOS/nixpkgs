{
  lib,
  buildPythonPackage,
  fetchPypi,
  aenum,
  dacite,
}:

buildPythonPackage rec {
  pname = "home-assistant-chip-clusters";
  version = "2024.3.2";
  format = "wheel";

  src = fetchPypi {
    inherit format version;
    pname = "home_assistant_chip_clusters";
    dist = "py3";
    python = "py3";
    hash = "sha256-Imdpqy7m81oxfkzj+82afSX9juK/SOCBIMoaPjK8G+Y=";
  };

  propagatedBuildInputs = [
    aenum
    dacite
  ];

  pythonImportsCheck = [
    "chip.clusters"
    "chip.clusters.ClusterObjects"
    "chip.tlv"
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
