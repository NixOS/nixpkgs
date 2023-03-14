version : builtins.getAttr version {
  "1.13.1" = {
    x86_64-darwin-cpu = {
      name = "libtorch-macos-1.13.1.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-1.13.1.zip";
      hash = "sha256-2ITO1hO3qb4lEHO7xV6Dn6bhxI4Ia2TLulqs2LM7+vY=";
    };
    x86_64-linux-cpu = {
      name = "libtorch-cxx11-abi-shared-with-deps-1.13.1-cpu.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.13.1%2Bcpu.zip";
      hash = "sha256-AXmlrtGNMVOYbQfvAQDUALlK1F0bMGNdm6RBtVuNvbo=";
    };
    x86_64-linux-cuda = {
      name = "libtorch-cxx11-abi-shared-with-deps-1.13.1-cu116.zip";
      url = "https://download.pytorch.org/libtorch/cu116/libtorch-cxx11-abi-shared-with-deps-1.13.1%2Bcu116.zip";
      hash = "sha256-CujIDlE9VqUuhSJcvUO6IlDWjmjEt54sMAJ4ZRjuziw=";
    };
  };
}
