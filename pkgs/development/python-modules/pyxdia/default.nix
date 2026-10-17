{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pypaInstallHook,
  wheelUnpackHook,
}:
let
  systemToPlatform = {
    "x86_64-linux" = "manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64";
    "aarch64-linux" = "manylinux_2_28_aarch64";
    "x86_64-darwin" = "macosx_13_0_x86_64";
    "aarch64-darwin" = "macosx_14_0_arm64";
  };

  platform = systemToPlatform.${stdenv.hostPlatform.system} or (throw "pyxdia: unsupported platform");

  hashes = {
    "x86_64-linux" = "sha256-890kZ4wY1uoTdyyKFY7epVAasXz3R+QFFjCle/BIhP4=";
    "aarch64-linux" = "sha256-xTqJNj/w6hJWgdGxp3xxgjWZkuOtvtzCRLo7PBBVJCY=";
    "x86_64-darwin" = "sha256-4ADDwAyhXcXyLnPIgHLtddTc7Ga7DPhkYuISECHrx0A=";
    "aarch64-darwin" = "sha256-kIo7xfqeRMOpl+mk+KmxUR7AmVeYspLzB3aNXoBcbHQ=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "pyxdia";
  version = "0.1.1";
  format = "wheel";

  # We need to fetch the wheels as xdialdr and blink are already included and would otherwise be downloaded at build-time
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    inherit platform;
    format = "wheel";
    python = "py3";
    dist = "py3";
    abi = "none";
    hash = hashes.${stdenv.hostPlatform.system};
  };

  nativeBuildInputs = [
    pypaInstallHook
    wheelUnpackHook
  ];

  pythonImportsCheck = [ "pyxdia" ];

  meta = {
    description = "Utility to extract useful program information from a PDB file in an easily parsed format";
    homepage = "https://github.com/mborgerson/xdia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ letgamer ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
