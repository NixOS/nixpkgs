{
  lib,
  fetchPypi,
  buildPythonPackage,
}:
let
  pypiMeta =
    {
      aarch64-darwin = {
        hash = "sha256-6hbIKv3R4deqrZyCGXwpXk84ej8elpPGYvfUi5DCmtM=";
        platform = "macosx_11_0_arm64";
      };
      x86_64-linux = {
        hash = "sha256-+2P+Be7xDWBHesqcGupt6gGdUmda0zIp8HkyJqzGgio=";
        platform = "manylinux1_x86_64";
      };
    }
    .${builtins.currentSystem};
in
buildPythonPackage rec {
  pname = "frida-python";
  version = "16.5.7";
  format = "wheel";

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
      "aarch64-darwin"
      "x86_64-linux"
    ];
  };
}
