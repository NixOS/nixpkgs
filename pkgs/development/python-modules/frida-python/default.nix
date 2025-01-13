{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "frida-python";
  version = "16.5.7";
  format = "wheel";

  src = fetchPypi {
    pname = "frida";
    inherit version format;
    hash = "sha256-+2P+Be7xDWBHesqcGupt6gGdUmda0zIp8HkyJqzGgio=";
    platform = "manylinux1_x86_64";
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
    ];
  };
}
