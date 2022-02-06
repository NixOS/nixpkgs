{ callPackage
, fetchurl
, gcc7
, gcc9
, gcc10
, lib
, stdenv
}:

let
  common = callPackage ./common.nix;
in
rec {
  cudatoolkit_10_0 = common {
    version = "10.0.130";
    url = "https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux";
    sha256 = "16p3bv1lwmyqpxil8r951h385sy9asc578afrc7lssa68c71ydcj";
    gcc = gcc7;
  };

  cudatoolkit_10_1 = common {
    version = "10.1.243";
    url = "https://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.243_418.87.00_linux.run";
    sha256 = "0caxhlv2bdq863dfp6wj7nad66ml81vasq2ayf11psvq2b12vhp7";
    gcc = gcc7;
  };

  cudatoolkit_10_2 = common {
    version = "10.2.89";
    url = "http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run";
    sha256 = "04fasl9sjkb1jvchvqgaqxprnprcz7a8r52249zp2ijarzyhf3an";
    gcc = gcc7;
  };

  cudatoolkit_10 = cudatoolkit_10_2;

  cudatoolkit_11_0 = common {
    version = "11.0.3";
    url = {
      aarch64-linux = "https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda_11.0.3_450.51.06_linux_sbsa.run";
      x86_64-linux  = "https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda_11.0.3_450.51.06_linux.run";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    sha256 = {
      aarch64-linux = "1wqqnz1pbgjzxni9al8vlmi3m86sb1hzy9nis6ikl161g4gzc90y";
      x86_64-linux  = "1h4c69nfrgm09jzv8xjnjcvpq8n4gnlii17v3wzqry5d13jc8ydh";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    gcc = gcc9;
  };

  cudatoolkit_11_1 = common {
    version = "11.1.1";
    url = {
      aarch64-linux = "https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda_11.1.1_455.32.00_linux_sbsa.run";
      x86_64-linux  = "https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda_11.1.1_455.32.00_linux.run";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    sha256 = {
      aarch64-linux = "00lg9fldglrllwxpnvmmkkqql0xkmp6ki3n8m2z0cp10papxpccs";
      x86_64-linux  = "13yxv2fgvdnqqbwh1zb80x4xhyfkbajfkwyfpdg9493010kngbiy";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    gcc = gcc9;
  };

  cudatoolkit_11_2 = common {
    version = "11.2.1";
    url = {
      aarch64-linux = "https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_460.32.03_linux_sbsa.run";
      x86_64-linux  = "https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_460.32.03_linux.run";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    sha256 = {
      aarch64-linux = "0pkc8nsynsq1rcsq9vv4qbrbx40g1i9gl9pmyb92q6kx8yk2ycjb";
      x86_64-linux  = "sha256-HamMuJfMX1inRFpKZspPaSaGdwbLOvWKZpzc2Nw9F8g=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    gcc = gcc9;
  };

  cudatoolkit_11_3 = common {
    version = "11.3.1";
    url = {
      aarch64-linux = "https://developer.download.nvidia.com/compute/cuda/11.3.1/local_installers/cuda_11.3.1_465.19.01_linux_sbsa.run";
      x86_64-linux  = "https://developer.download.nvidia.com/compute/cuda/11.3.1/local_installers/cuda_11.3.1_465.19.01_linux.run";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    sha256 = {
      aarch64-linux = "0k3fa2zl6n60a6sn5xg169gjfrhb7wcbql08qad2h8cbm0yhv69r";
      x86_64-linux  = "0d19pwcqin76scbw1s5kgj8n0z1p4v1hyfldqmamilyfxycfm4xd";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    gcc = gcc9;
  };

  cudatoolkit_11_4 = common {
    version = "11.4.2";
    url = {
      aarch64-linux = "https://developer.download.nvidia.com/compute/cuda/11.4.2/local_installers/cuda_11.4.2_470.57.02_linux_sbsa.run";
      x86_64-linux  = "https://developer.download.nvidia.com/compute/cuda/11.4.2/local_installers/cuda_11.4.2_470.57.02_linux.run";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    sha256 = {
      aarch64-linux = "1n40ypd9ik2gfgmzxprzkn7v5h5l9hzymidpvz40d5ij0qpabi7j";
      x86_64-linux  = "sha256-u9h8oOkT+DdFSnljZ0c1E83e9VUILk2G7Zo4ZZzIHwo=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    gcc = gcc10; # can bump to 11 along with stdenv.cc
  };

  cudatoolkit_11_5 = common {
    version = "11.5.0";
    url = {
      aarch64-linux = "https://developer.download.nvidia.com/compute/cuda/11.5.0/local_installers/cuda_11.5.0_495.29.05_linux_sbsa.run";
      x86_64-linux  = "https://developer.download.nvidia.com/compute/cuda/11.5.0/local_installers/cuda_11.5.0_495.29.05_linux.run";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    sha256 = {
      aarch64-linux = "1i6qlwm6zj1cm2qx0kb19rzn42ciqfng8m5clm8wfv4mrhhdbabf";
      x86_64-linux  = "sha256-rgoWk9lJfPPYHmlIlD43lGNpANtxyY1Y7v2sr38aHkw=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    gcc = gcc10; # can bump to 11 along with stdenv.cc
  };

  cudatoolkit_11 = cudatoolkit_11_4;
}
