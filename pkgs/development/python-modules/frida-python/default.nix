{
  lib,
  fetchPypi,
  stdenvNoCC,
  buildPythonPackage,
}:
let
  version = "17.15.3";
  format = "wheel";
  inherit (stdenvNoCC.hostPlatform) system;

  # https://pypi.org/project/frida/#files
  pypiMeta =
    {
      x86_64-linux = {
        hash = "sha256-q8E4uhzfFyZV7P/Bft+UviaKX78z49TkXBM7p0oQ/HY=";
        platform = "manylinux1_x86_64";
      };
      aarch64-linux = {
        hash = "sha256-00gr7AWA0ynXmZrvNWphPWkkpeDOOqWIZMKe+jbeAFA=";
        platform = "manylinux2014_aarch64";
      };
      x86_64-darwin = {
        hash = "sha256-7d7jWTT5yueVBfIYSZoxCDHXcxjom9JP9nfzBJqxd8I=";
        platform = "macosx_10_13_x86_64";
      };
      aarch64-darwin = {
        hash = "sha256-AmTFwqjE2huyFwabx6gWdRnymy+pPVqBvlJWzQQb3H4=";
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
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
