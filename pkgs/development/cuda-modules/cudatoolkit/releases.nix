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
  "11.0" = {
    version = "11.0.3";
    url = "https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda_11.0.3_450.51.06_linux.run";
    sha256 = "1h4c69nfrgm09jzv8xjnjcvpq8n4gnlii17v3wzqry5d13jc8ydh";
  };

  "11.1" = {
    version = "11.1.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda_11.1.1_455.32.00_linux.run";
    sha256 = "13yxv2fgvdnqqbwh1zb80x4xhyfkbajfkwyfpdg9493010kngbiy";
  };

  "11.2" = {
    version = "11.2.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_460.32.03_linux.run";
    sha256 = "sha256-HamMuJfMX1inRFpKZspPaSaGdwbLOvWKZpzc2Nw9F8g=";
  };

  "11.3" = {
    version = "11.3.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.3.1/local_installers/cuda_11.3.1_465.19.01_linux.run";
    sha256 = "0d19pwcqin76scbw1s5kgj8n0z1p4v1hyfldqmamilyfxycfm4xd";
  };

  "11.4" = {
    version = "11.4.2";
    url = "https://developer.download.nvidia.com/compute/cuda/11.4.2/local_installers/cuda_11.4.2_470.57.02_linux.run";
    sha256 = "sha256-u9h8oOkT+DdFSnljZ0c1E83e9VUILk2G7Zo4ZZzIHwo=";
  };

  "11.5" = {
    version = "11.5.0";
    url = "https://developer.download.nvidia.com/compute/cuda/11.5.0/local_installers/cuda_11.5.0_495.29.05_linux.run";
    sha256 = "sha256-rgoWk9lJfPPYHmlIlD43lGNpANtxyY1Y7v2sr38aHkw=";
  };

  "11.6" = {
    version = "11.6.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.6.1/local_installers/cuda_11.6.1_510.47.03_linux.run";
    sha256 = "sha256-qyGa/OALdCABEyaYZvv/derQN7z8I1UagzjCaEyYTX4=";
  };

  "11.7" = {
    version = "11.7.0";
    url = "https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda_11.7.0_515.43.04_linux.run";
    sha256 = "sha256-CH/fy7ofeVQ7H3jkOo39rF9tskLQQt3oIOFtwYWJLyY=";
  };

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
    version = "12.3.0";
    url = "https://developer.download.nvidia.com/compute/cuda/12.3.0/local_installers/cuda_12.3.0_545.23.06_linux.run";
    sha256 = "sha256-fBP6zjr2TW4WSNbjEB0xyBEedHFDrLAHfZc8FpCCBCI=";
  };

  "12.4" = {
    version = "12.4.0";
    url = "https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda_12.4.0_550.54.14_linux.run";
    sha256 = "sha256-5qhC9OypSQV1zbaLaxu3jUe5Wol95I3uKSxDGJLlfRc=";
  };
}
