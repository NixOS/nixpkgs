{
  lib,
  fetchPypi,
  stdenvNoCC,
  buildPythonPackage,
}:
let
  version = "16.7.11";
  format = "wheel";
  inherit (stdenvNoCC.hostPlatform) system;

  # https://pypi.org/project/frida/#files
  pypiMeta =
    {
      x86_64-linux = {
        hash = "sha256-aAPVZPz1mn73JuQPGJ/PAOUAtaufeHehSKHzaBmVFF8=";
        platform = "manylinux1_x86_64";
      };
      aarch64-linux = {
        hash = "sha256-mQgfMJ6esH41MXnGZQUwF4j8gDgzfyBDUQo5Kw8TGa4=";
        platform = "manylinux2014_aarch64";
      };
      x86_64-darwin = {
        hash = "sha256-TuWvQ4oDkK5Fn/bp0G3eAhvDLlv0tzIQ8dKtysX36w0=";
        platform = "macosx_10_13_x86_64";
      };
      aarch64-darwin = {
        hash = "sha256-QWfWbGnKeuKiGoD0srnnMsbWPYFcYsbO/Oy68uJIRjI=";
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
    license = lib.licenses.wxWindows;
    maintainers = with lib.maintainers; [ s1341 ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
