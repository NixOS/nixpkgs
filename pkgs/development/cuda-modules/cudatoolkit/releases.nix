# Type Aliases
# CudaVersion = String (two-component version, e.g. "10.0")
# Release = {
#   version: String
#     - The version of CUDA.
#   url: String
#     - The URL to download the CUDA installer from.
#   sha256: String
#     - The SHA256 checksum of the CUDA installer.
# }
# Releases = AttrSet CudaVersion Release
{
  "11.8" = {
    version = "11.8.0";
    url = "https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run";
    sha256 = "sha256-kiPErzrr5Ke77Zq9mxY7A6GzS4VfvCtKDRtwasCaWhY=";
  };

  "12.0" = {
    version = "12.0.1";
    url = "https://developer.download.nvidia.com/compute/cuda/12.0.1/local_installers/cuda_12.0.1_525.85.12_linux.run";
    sha256 = "sha256-GyBaBicvFGP0dydv2rkD8/ZmkXwGjlIHOAAeacehh1s=";
  };

  "12.1" = {
    version = "12.1.1";
    url = "https://developer.download.nvidia.com/compute/cuda/12.1.1/local_installers/cuda_12.1.1_530.30.02_linux.run";
    sha256 = "sha256-10Ai1B2AEFMZ36Ib7qObd6W5kZU5wEh6BcqvJEbWpw4=";
  };

  "12.2" = {
    version = "12.2.2";
    url = "https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.run";
    sha256 = "sha256-Kzmq4+dhjZ9Zo8j6HxvGHynAsODfdfsFB2uts1KVLvI=";
  };

  "12.3" = {
    version = "12.3.2";
    url = "https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda_12.3.2_545.23.08_linux.run";
    sha256 = "sha256-JLKvyfdw2M9D1vp63C6/1HxAhNsBvdoc484KTUk7pls=";
  };

  "12.4" = {
    version = "12.4.1";
    url = "https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run";
    sha256 = "sha256-Nn0imbOkWIq0h6bScnbKXZ6tbjlJBPGLzLnhJDO5xPs=";
  };

  "12.5" = {
    version = "12.5.1";
    url = "https://developer.download.nvidia.com/compute/cuda/12.5.1/local_installers/cuda_12.5.1_555.42.06_linux.run";
    sha256 = "sha256-teCneeCJyGYQBRFBxM9Ji+70MYWOxjOYEHORcn7L2wQ=";
  };

  "12.6" = {
    version = "12.6.3";
    url = "https://developer.download.nvidia.com/compute/cuda/12.6.3/local_installers/cuda_12.6.3_560.35.05_linux.run";
    sha256 = "sha256-gdYOSARHlteIOqigSa/mUBuEPyxFY5s3A7I3jeMNVdM=";
  };

  "12.8" = {
    version = "12.8.1";
    url = "https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda_12.8.1_570.124.06_linux.run";
    sha256 = "sha256-Io9ryvW3YY0DKTn0MZFPyS0OXtOevjcJiiRQLyahl5c=";
  };

  "12.9" = {
    version = "12.9.1";
    url = "https://developer.download.nvidia.com/compute/cuda/12.9.1/local_installers/cuda_12.9.1_575.57.08_linux.run";
    sha256 = "sha256-D22Abd2HIw0q2+imAGqdIBRP29qd4tasxnfapdA2QXo=";
  };
}
