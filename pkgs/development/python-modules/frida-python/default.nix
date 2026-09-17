{
  lib,
  fetchPypi,
  stdenvNoCC,
  buildPythonPackage,
}:
let
  version = "17.18.0";
  format = "wheel";
  inherit (stdenvNoCC.hostPlatform) system;

  # https://pypi.org/project/frida/#files
  pypiMeta =
    {
      x86_64-linux = {
        hash = "sha256-2lbR6pyvsg5iMmHckdqSo7UCecYBYGVPUBTB6P6TPUQ=";
        platform = "manylinux1_x86_64";
      };
      aarch64-linux = {
        hash = "sha256-3/w3dcqQyXOtGyBg+DGgj/qkNxATLVR3hbzlsAqLyWk=";
        platform = "manylinux2014_aarch64";
      };
      aarch64-darwin = {
        hash = "sha256-jpejOWn0R7q5+cKsOlj65KFNEhVvYLqiiKzwRepxOs0=";
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
