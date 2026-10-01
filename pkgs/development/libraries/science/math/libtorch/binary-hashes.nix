version:
builtins.getAttr version {
  "2.9.0" = {
    aarch64-darwin-cpu = {
      name = "libtorch-macos-arm64-2.9.0.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-arm64-2.9.0.zip";
      hash = "sha256-inwzvGPPKK6KVBoMijpXVKV+V3QcmQbBhYdFlZbZ/ho=";
    };
    x86_64-linux-cpu = {
      name = "libtorch-shared-with-deps-2.9.0-cpu.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-shared-with-deps-2.9.0%2Bcpu.zip";
      hash = "sha256-GrfTahXLCOeMQD07+yEU4K6WCbmQMjv0GXc+EMS95e0=";
    };
    x86_64-linux-cuda = {
      name = "libtorch-shared-with-deps-2.9.0-cu130.zip";
      url = "https://download.pytorch.org/libtorch/cu130/libtorch-shared-with-deps-2.9.0%2Bcu130.zip";
      hash = "sha256-u8l7JIy2rdk6nxv6UxNmFcfOVcpjvZnIEr5CczVNRDQ=";
    };
  };
}
