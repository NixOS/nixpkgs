{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "7.5.18";
  sha256 = "1i8rx7bc1v01v3lmcbi26hwyqkrqsdiinfmfz0ix6s9b3rngnpr4";
  url = "http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run";
})
