{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "7.0.28";
  sha256 = "1km5hpiimx11jcazg0h3mjzk220klwahs2vfqhjavpds5ff2wafi";
  url = "http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run";
})
