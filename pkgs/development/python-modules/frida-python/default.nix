{
  lib,
  fetchPypi,
  stdenvNoCC,
  buildPythonPackage,
}:
let
  version = "17.2.11";
  format = "wheel";
  inherit (stdenvNoCC.hostPlatform) system;

  # https://pypi.org/project/frida/#files
  pypiMeta =
    {
      x86_64-linux = {
        hash = "sha256-PSCT5Y3JaOo9uJgCzXQVmcDvNxUEEN5dvjRxiEMcJEQ=";
        platform = "manylinux1_x86_64";
      };
      aarch64-linux = {
        hash = "sha256-UH+f6Pj1BS2hcwz3WoSsBGRXOIM/y8D0ymk8s7BU2nw=";
        platform = "manylinux2014_aarch64";
      };
      x86_64-darwin = {
        hash = "sha256-zZms5eIguKTl5SYWtDNQwROPM2+5t8JVp/itIl9FkXs=";
        platform = "macosx_10_13_x86_64";
      };
      aarch64-darwin = {
        hash = "sha256-vzyHYlstwm1GT1jKc0g5Yr6JVte9WGn+hALYpkefKBY=";
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
