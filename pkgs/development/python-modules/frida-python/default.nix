{
  lib,
  fetchPypi,
  stdenvNoCC,
  buildPythonPackage,
}:
let
  version = "17.9.11";
  format = "wheel";
  inherit (stdenvNoCC.hostPlatform) system;

  # https://pypi.org/project/frida/#files
  pypiMeta =
    {
      x86_64-linux = {
        hash = "sha256-ovITi0zxPqJECChrx8cAeIw7m7NjGHa+cl1NomYL718=";
        platform = "manylinux1_x86_64";
      };
      aarch64-linux = {
        hash = "sha256-kDSBWC+G2m3pZ6YWhMjkvtXfR6HMVq5zxsxZUmBprrM=";
        platform = "manylinux2014_aarch64";
      };
      x86_64-darwin = {
        hash = "sha256-op8QM6f5LKCoozKawTi8hYZRO5VJ1kzWjSk62urGJLQ=";
        platform = "macosx_10_13_x86_64";
      };
      aarch64-darwin = {
        hash = "sha256-9JmPcE4CxzHiNLg6jMpSt/CC0eGk0VyKr1uzUTyQRqI=";
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
