version: {
  x86_64-darwin-cpu = {
    url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-${version}.zip";
    hash = "sha256-FYgnd5zlycjCYnP5bZcjpMdGYXrRERwhFFBYo/SJgzs=";
  };
  x86_64-linux-cpu = {
    url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-${version}%2Bcpu.zip";
    hash = "sha256-xneCcVrY25Whgbs/kPbwdS1Lc0e6RxsDRpA5lHTZigc=";
  };
  x86_64-linux-cuda = {
    url = "https://download.pytorch.org/libtorch/cu111/libtorch-cxx11-abi-shared-with-deps-${version}%2Bcu111.zip";
    hash = "sha256-VW+TW00nD49GBztCyxHE4dTyy81aN/kfYE3hKQOIm50=";
  };
}
