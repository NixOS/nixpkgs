version: builtins.getAttr version {
 "2.3.0" = {
     aarch64-darwin-cpu = {
      name = "libtorch-macos-arm64-2.3.0.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-arm64-2.3.0.zip";
      hash = "sha256-l4qY1jbsECN5qm7dWJ2jSvKuQwQ/HI6G6Vq1Kh2rxkM=";
    };
    x86_64-linux-cpu = {
      name = "libtorch-cxx11-abi-shared-with-deps-2.3.0-cpu.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.3.0%2Bcpu.zip";
      hash = "sha256-dKAk6UusK2eQIcP0oMXh9cnufMpy5Ph4SGPkIPPV6ds=";
    };
    x86_64-linux-cuda = {
      name = "libtorch-cxx11-abi-shared-with-deps-2.3.0-cu121.zip";
      url = "https://download.pytorch.org/libtorch/cu121/libtorch-cxx11-abi-shared-with-deps-2.3.0%2Bcu121.zip";
      hash = "sha256-6B+NF6q78I2WKFudn8bK+eNYDi1zQ7mdgv06fZbm2rE=";
    };
  };
}
