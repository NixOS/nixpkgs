{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder

# build
, autoPatchelfHook

# runtime
, openssl_1_1

# propagates
, coloredlogs
, construct
, dacite
, rich
, pyyaml
, ipdb
, deprecation
, mobly
, pygobject3
}:

buildPythonPackage rec {
  pname = "home-assistant-chip-core";
  version = "2023.4.1";
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = let
    system = {
      "aarch64-linux" = {
        name = "aarch64";
        hash = "sha256-Rke4cVHdpJjrqqiNKWFwglerr61VyiTNKj8AhLE0+Xo=";
      };
      "x86_64-linux" = {
        name = "x86_64";
        hash = "sha256-ihbbNFuR+3SLzdZgApJawpwnZeo1HPoOBWJXkY+5RSM=";
      };
    }.${stdenv.system} or (throw "Unsupported system");
  in fetchPypi {
    pname = "home_assistant_chip_core";
    inherit version format;
    dist = "cp37";
    python = "cp37";
    abi = "abi3";
    platform = "manylinux_2_31_${system.name}";
    hash = system.hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    openssl_1_1
  ];

  propagatedBuildInputs = [
    coloredlogs
    construct
    dacite
    rich
    pyyaml
    ipdb
    deprecation
    mobly
    pygobject3
  ];

  pythonImportsCheck = [
    "chip"
    "chip.ble"
    # https://github.com/project-chip/connectedhomeip/pull/24376
    #"chip.configuration"
    "chip.discovery"
    "chip.native"
    "chip.storage"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Python-base APIs and tools for CHIP";
    homepage = "https://github.com/home-assistant-libs/chip-wheels";
    changelog = "https://github.com/home-assistant-libs/chip-wheels/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
