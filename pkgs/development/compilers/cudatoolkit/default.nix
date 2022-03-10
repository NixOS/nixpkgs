{ callPackage
, fetchurl
, gcc7
, gcc9
, gcc10
, lib
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
    url = "https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda_11.0.3_450.51.06_linux.run";
    sha256 = "1h4c69nfrgm09jzv8xjnjcvpq8n4gnlii17v3wzqry5d13jc8ydh";

    gcc = gcc9;
  };

  cudatoolkit_11_1 = common {
    version = "11.1.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda_11.1.1_455.32.00_linux.run";
    sha256 = "13yxv2fgvdnqqbwh1zb80x4xhyfkbajfkwyfpdg9493010kngbiy";
    gcc = gcc9;
  };

  cudatoolkit_11_2 = common {
    version = "11.2.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_460.32.03_linux.run";
    sha256 = "sha256-HamMuJfMX1inRFpKZspPaSaGdwbLOvWKZpzc2Nw9F8g=";
    gcc = gcc9;
  };

  cudatoolkit_11_3 = common {
    version = "11.3.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.3.1/local_installers/cuda_11.3.1_465.19.01_linux.run";
    sha256 = "0d19pwcqin76scbw1s5kgj8n0z1p4v1hyfldqmamilyfxycfm4xd";
    gcc = gcc9;
  };

  cudatoolkit_11_4 = common {
    version = "11.4.2";
    url = "https://developer.download.nvidia.com/compute/cuda/11.4.2/local_installers/cuda_11.4.2_470.57.02_linux.run";
    sha256 = "sha256-u9h8oOkT+DdFSnljZ0c1E83e9VUILk2G7Zo4ZZzIHwo=";
    gcc = gcc10; # can bump to 11 along with stdenv.cc
  };

  cudatoolkit_11_5 = common {
    version = "11.5.0";
    url = "https://developer.download.nvidia.com/compute/cuda/11.5.0/local_installers/cuda_11.5.0_495.29.05_linux.run";
    sha256 = "sha256-rgoWk9lJfPPYHmlIlD43lGNpANtxyY1Y7v2sr38aHkw=";
    gcc = gcc10; # can bump to 11 along with stdenv.cc
  };

  cudatoolkit_11_6 = common {
    version = "11.6.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.6.1/local_installers/cuda_11.6.1_510.47.03_linux.run";
    sha256 = "sha256-qyGa/OALdCABEyaYZvv/derQN7z8I1UagzjCaEyYTX4=";
    gcc = gcc10; # can bump to 11 along with stdenv.cc
  };

  cudatoolkit_11 = cudatoolkit_11_4;
}
