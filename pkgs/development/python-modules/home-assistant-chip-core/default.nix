{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder

# build
, autoPatchelfHook

# runtime
, libnl
, openssl_1_1

# propagates
, aenum
, coloredlogs
, construct
, cryptography
, dacite
, ecdsa
, rich
, pyyaml
, ipdb
, deprecation
, mobly
, pygobject3
}:

buildPythonPackage rec {
  pname = "home-assistant-chip-core";
  version = "2023.6.0";
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = let
    system = {
      "aarch64-linux" = {
        name = "aarch64";
        hash = "sha256-fR+ea25SqOMksBJXgSjuVvv2xSBoadZmPWP0IwxpiMA=";
      };
      "x86_64-linux" = {
        name = "x86_64";
        hash = "sha256-bRP82jTVSJS46WuO8MVWFvte+2mCOSsGFDBaXdmdPHI=";
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
    libnl
    openssl_1_1
  ];

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
