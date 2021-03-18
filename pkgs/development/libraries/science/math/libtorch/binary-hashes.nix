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
    url = "https://download.pytorch.org/libtorch/cu111/libtorch-cxx11-abi-shared-with-deps-${version}%2Bcu111.zip";
    hash = "sha256-uQ7ptOuzowJ0JSPIvJHyNotBfpsqAnxpMDLq7Vl6L00=";
  };
}
