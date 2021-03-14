version: {
  x86_64-darwin-cpu = {
    url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-${version}.zip";
    hash = "sha256-V1lbztMB09wyWjdiJrwVwJ00DT8Kihy/TC2cKmdBLIE=";
  };
  x86_64-linux-cpu = {
    url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-${version}%2Bcpu.zip";
    hash = "sha256-xBaNyI7eiQnSArHMITonrQQLZnZCZK/SWKOTWnxzdpc=";
  };
  x86_64-linux-cuda = {
    url = "https://download.pytorch.org/libtorch/cu102/libtorch-cxx11-abi-shared-with-deps-${version}.zip";
    hash = "sha256-rNEyE4+jfeX7cU0aNYd5b0pZGYT0PNPnDnS1PIsrMeM=";
  };
}
