{
  lib,
  buildPythonPackage,
  fetchurl,
  stdenv,
}:

buildPythonPackage rec {
  pname = "pennylane-catalyst";
  version = "0.13.0";
  format = "wheel";

  src =
    fetchurl
      {
        x86_64-linux = {
          url = "https://files.pythonhosted.org/packages/55/a4/baffa657d28149ec1e4ca0d54a98ead92382878217725688f7ee44beb1fa/pennylane_catalyst-0.13.0-cp312-abi3-manylinux_2_28_x86_64.whl";
          hash = "sha256-BLjJ2xNL6n0oWIJGKS7IpZ+Qszbrq49DNViQKZtzEtk=";
        };
      }
      ."${stdenv.hostPlatform.system}"
        or (throw "Unsupported system for ${pname}: ${stdenv.hostPlatform.system}");

  meta = {
    changelog = "https://github.com/PennyLaneAI/catalyst/releases/tag/${version}";
    description = "Provides OpenBLAS for python packaging";
    homepage = "https://github.com/PennyLaneAI/catalyst";
    license = lib.licenses.bsd2;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      anderscs
    ];
  };
}
