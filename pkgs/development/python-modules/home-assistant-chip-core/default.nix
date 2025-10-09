{
  lib,
  buildPythonPackage,
  pythonOlder,
  aenum,
  home-assistant-chip-wheels,
  coloredlogs,
  construct,
  cryptography,
  dacite,
  deprecation,
  ecdsa,
  ipdb,
  mobly,
  pygobject3,
  pyyaml,
  rich,
}:

buildPythonPackage rec {
  pname = "home-assistant-chip-core";
  inherit (home-assistant-chip-wheels) version;
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = home-assistant-chip-wheels;

  # format=wheel needs src to be a wheel not a folder of wheels
  preUnpack = ''
    src=($src/home_assistant_chip_core*.whl)
  '';

  propagatedBuildInputs = [
    aenum
    coloredlogs
    construct
    cryptography
    dacite
    ecdsa
    rich
    pyyaml
    ipdb
    deprecation
    mobly
    pygobject3
  ]
  ++ home-assistant-chip-wheels.propagatedBuildInputs;

  pythonNamespaces = [
    "chip"
    "chip.clusters"
  ];

  pythonImportsCheck = [
    "chip"
    "chip.ble"
    "chip.configuration"
    "chip.discovery"
    "chip.exceptions"
    "chip.native"
    "chip.storage"
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
