version: builtins.getAttr version {
 "2.2.2" = {
     aarch64-darwin-cpu = {
      name = "libtorch-macos-arm64-2.2.2.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-arm64-2.2.2.zip";
      hash = "sha256-zXviMxGW0wpJDIbb++qaJLL8OwJPuT38KqRRXkEFGeA=";
    };
    x86_64-darwin-cpu = {
      name = "libtorch-macos-x86_64-2.2.2.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-x86_64-2.2.2.zip";
      hash = "sha256-GcMf+0Cwfz6D8FC5bhtxCdBC4NgysO+2xA7EqXeb2fk=";
    };
    x86_64-linux-cpu = {
      name = "libtorch-cxx11-abi-shared-with-deps-2.2.2-cpu.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.2.2%2Bcpu.zip";
      hash = "sha256-REVmlpMC9xGHfKXtPbw1wOzhNf+G0wNRJBwmwen8fLE=";
    };
    x86_64-linux-cuda = {
      name = "libtorch-cxx11-abi-shared-with-deps-2.2.2-cu121.zip";
      url = "https://download.pytorch.org/libtorch/cu121/libtorch-cxx11-abi-shared-with-deps-2.2.2%2Bcu121.zip";
      hash = "sha256-UO5sz4tTQrWrnrjlWiwt1khdmGeSNRU9L5h7i/Ez+tk=";
    };
  };
}
