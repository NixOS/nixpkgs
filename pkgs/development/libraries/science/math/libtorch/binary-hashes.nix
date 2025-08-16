version:
builtins.getAttr version {
  "2.7.0" = {
    aarch64-darwin-cpu = {
      name = "libtorch-macos-arm64-2.7.0.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-arm64-2.7.0.zip";
      sha256 = "1maj742qr4kvzlky8syg3n72xp2hqsskpfh7dwmx3986wj4m9hlr";
    };
    x86_64-linux-cpu = {
      name = "libtorch-cxx11-abi-shared-with-deps-2.7.0-cpu.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.7.0%2Bcpu.zip";
      sha256 = "0cvj3yajx9ysy4ych9y1qib2m0z618fwydac8l1r839lw59hq4gi";
    };
    x86_64-linux-cuda = {
      name = "libtorch-cxx11-abi-shared-with-deps-2.7.0-cu128.zip";
      url = "https://download.pytorch.org/libtorch/cu128/libtorch-cxx11-abi-shared-with-deps-2.7.0%2Bcu128.zip";
      sha256 = "1is5g23i2plmfg6lvpqcbnkmwzxn3lxyygklrcsasj762qckmmyr";
    };
  };
}
