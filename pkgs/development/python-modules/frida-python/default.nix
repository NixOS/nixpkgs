{
  lib,
  fetchPypi,
  stdenvNoCC,
  buildPythonPackage,
}:
let
  version = "17.27.5";
  format = "wheel";
  inherit (stdenvNoCC.hostPlatform) system;

  # https://pypi.org/project/frida/#files
  pypiMeta =
    {
      x86_64-linux = {
        hash = "sha256-H7BWLK6Po+kjG6RwORyvNCueq4azf5015pumW1g32PE=";
        platform = "manylinux1_x86_64";
      };
      aarch64-linux = {
        hash = "sha256-zJChZGDaUPXZU/eGm2Tmk8ohdL+l8a1+d4SsJovhDoY=";
        platform = "manylinux2014_aarch64";
      };
      aarch64-darwin = {
        hash = "sha256-KlSQ7SVBxGX4BbplDuvCO0QqBsb54yj5hfDVrVNQBuE=";
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

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers (Python bindings)";
    homepage = "https://www.frida.re";
    license = with lib.licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
    maintainers = with lib.maintainers; [
      s1341
      eyjhb
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
