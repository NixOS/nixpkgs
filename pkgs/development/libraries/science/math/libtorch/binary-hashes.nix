version: {
  x86_64-darwin-cpu = {
    url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-${version}.zip";
    sha256 = "1912lklil0i7i10j1fm4qzcq96cc8c281l9fn5gfbwa2wwry0r59";
  };
  x86_64-linux-cpu = {
    url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-${version}%2Bcpu.zip";
    sha256 = "0jdd7bjcy20xz2gfv8f61zdrbzxz5425bnqaaqgrwpzvd45ay8px";
  };
  x86_64-linux-cuda = {
    url = "https://download.pytorch.org/libtorch/cu102/libtorch-cxx11-abi-shared-with-deps-${version}.zip";
    sha256 = "1ag6lvf3a400ivqq4g9cxpmxzlfrga0y5ssjy0rfpw6i1xljibn6";
  };
}
