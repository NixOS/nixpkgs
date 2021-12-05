version:
builtins.getAttr version {
  "1.10.0" = {
    x86_64-darwin-cpu = {
      name = "libtorch-macos-1.10.0.zip";
      url =
        "https://download.pytorch.org/libtorch/cpu/libtorch-macos-1.10.0.zip";
      hash = "sha256-HSisxHs466c6XwvZEbkV/1kVNBzJOy3uVw9Bh497Vk8=";
    };
    x86_64-linux-cpu = {
      name = "libtorch-cxx11-abi-shared-with-deps-1.10.0-cpu.zip";
      url =
        "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.10.0%2Bcpu.zip";
      hash = "sha256-wAtA+AZx3HjaFbsrbyfkSXjYM0BP8H5HwCgyHbgJXJ0=";
    };
    x86_64-linux-cuda = {
      name = "libtorch-cxx11-abi-shared-with-deps-1.10.0-cu113.zip";
      url =
        "https://download.pytorch.org/libtorch/cu113/libtorch-cxx11-abi-shared-with-deps-1.10.0%2Bcu113.zip";
      hash = "sha256-jPylK4j0V8SEQ8cZU+O22P7kQ28wanIB0GkBzRGyTj8=";
    };
  };
}
