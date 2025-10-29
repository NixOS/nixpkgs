{
  lib,
  fetchPypi,
  stdenvNoCC,
  buildPythonPackage,
}:
let
  version = "17.4.1";
  format = "wheel";
  inherit (stdenvNoCC.hostPlatform) system;

  # https://pypi.org/project/frida/#files
  pypiMeta =
    {
      x86_64-linux = {
        hash = "sha256-bg4S1mHU9RODGx8lDvCI3o+CpBqaljZQqzLVM9ffiMQ=";
        platform = "manylinux1_x86_64";
      };
      aarch64-linux = {
        hash = "sha256-3e4IBkRCNlELLn/ZUhJBcyiBfSuR8bDkLOAiWVQMRkg=";
        platform = "manylinux2014_aarch64";
      };
      x86_64-darwin = {
        hash = "sha256-o8hVponku8CY2p8/ZkI22rUPCHU5bGT7S4gqLAr9h04=";
        platform = "macosx_10_13_x86_64";
      };
      aarch64-darwin = {
        hash = "sha256-aHu1JpnKDMrlrjOve6UnLDK1hYblJZF9bKlbxPRKeio=";
        platform = "macosx_11_0_arm64";
      };
    }
    .${system} or (throw "Unsupported system: ${system}");
in
buildPythonPackage {
  pname = "frida-python";
  inherit version format;

  src = fetchPypi {
    pname = "frida";
    inherit version format;
    inherit (pypiMeta) hash platform;
    abi = "abi3";
    python = "cp37";
    dist = "cp37";
  };

  pythonImportsCheck = [
    "frida"
    "frida._frida"
  ];

  meta = {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers (Python bindings)";
    homepage = "https://www.frida.re";
    license = with lib.licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
    maintainers = with lib.maintainers; [ s1341 ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
