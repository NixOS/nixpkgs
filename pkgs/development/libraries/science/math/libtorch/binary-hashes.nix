version : builtins.getAttr version {
  "2.0.0" = {
    x86_64-darwin-cpu = {
      name = "libtorch-macos-2.0.0.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-2.0.0.zip";
      hash = "sha256-u6y5IeYoiOC0yQ/k6JCChDs9lXWccLxUorgR8L62lkM=";
    };
    x86_64-linux-cpu = {
      name = "libtorch-cxx11-abi-shared-with-deps-2.0.0-cpu.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.0.0%2Bcpu.zip";
      hash = "sha256-BoZQ2MC1CDVVGfX3SHC3mEpLGWO8XK7AcLcHJXDsXuc=";
    };
    x86_64-linux-cuda = {
      name = "libtorch-cxx11-abi-shared-with-deps-2.0.0-cu118.zip";
      url = "https://download.pytorch.org/libtorch/cu118/libtorch-cxx11-abi-shared-with-deps-2.0.0%2Bcu118.zip";
      hash = "sha256-Dpw9kQdA1NI9EOT7JBKwQP4wZT6lizcnKKTQ8WVJCZc=";
    };
  };
}
