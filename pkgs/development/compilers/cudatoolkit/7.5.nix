{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "7.5.18";
  sha256 = "1v2ylzp34ijyhcxyh5p6i0cwawwbbdhni2l5l4qm21s1cx9ish88";
  url = "http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run";
})
