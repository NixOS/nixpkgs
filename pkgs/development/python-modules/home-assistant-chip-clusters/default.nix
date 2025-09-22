{
  lib,
  buildPythonPackage,
  home-assistant-chip-wheels,
  aenum,
  dacite,
}:

buildPythonPackage rec {
  pname = "home-assistant-chip-clusters";
  inherit (home-assistant-chip-wheels) version;
  format = "wheel";

  src = home-assistant-chip-wheels;

  # format=wheel needs src to be a wheel not a folder of wheels
  preUnpack = ''
    src=($src/home_assistant_chip_clusters*.whl)
  '';

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
    teams = [ teams.home-assistant ];
  };
}
