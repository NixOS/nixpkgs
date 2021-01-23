version: {
  x86_64-darwin-cpu = {
    url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-${version}.zip";
    sha256 = "0n93r7bq6wjjxkczp8r5pjm1nvl75wns5higsvh7gsir0j6k7b5b";
  };
  x86_64-linux-cpu = {
    url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-${version}%2Bcpu.zip";
    sha256 = "0gpcj90nxyc69p53jiqwamd4gi7wzssk29csxfsyxsrzg3h36s7z";
  };
  x86_64-linux-cuda = {
    url = "https://download.pytorch.org/libtorch/cu102/libtorch-cxx11-abi-shared-with-deps-${version}.zip";
    sha256 = "01z61ryrflq306x7ay97k2fqc2q2z9c4c1zcnjfzr6412vg4fjb8";
  };
}
