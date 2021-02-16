{ lib
, callPackage
, fetchurl
, gcc48
, gcc6
, gcc7
, gcc9
}:

let
  common = callPackage ./common.nix;
in rec {
  cudatoolkit_9_0 = common {
    version = "9.0.176.1";
    url = "https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run";
    sha256 = "0308rmmychxfa4inb1ird9bpgfppgr9yrfg1qp0val5azqik91ln";
    runPatches = [
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/1/cuda_9.0.176.1_linux-run";
        sha256 = "1vbqg97pq9z9c8nqvckiwmq3ljm88m7gaizikzxbvz01izh67gx4";
      })
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/2/cuda_9.0.176.2_linux-run";
        sha256 = "1sz5dijbx9yf7drfipdxav5a5g6sxy4w6vi9xav0lb6m2xnmyd7c";
      })
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/3/cuda_9.0.176.3_linux-run";
        sha256 = "1jm83bxpscpjhzs5q3qijdgjm0r8qrdlgkj7y08fq8c0v8q2r7j2";
      })
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/4/cuda_9.0.176.4_linux-run";
        sha256 = "0pymg3mymsa2n48y0njz3spzlkm15lvjzw8fms1q83zslz4x0lwk";
      })
    ];
    gcc = gcc6;
  };

  cudatoolkit_9_1 = common {
    version = "9.1.85.3";
    url = "https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux";
    sha256 = "0lz9bwhck1ax4xf1fyb5nicb7l1kssslj518z64iirpy2qmwg5l4";
    runPatches = [
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.1/Prod/patches/1/cuda_9.1.85.1_linux";
        sha256 = "1f53ij5nb7g0vb5pcpaqvkaj1x4mfq3l0mhkfnqbk8sfrvby775g";
      })
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.1/Prod/patches/2/cuda_9.1.85.2_linux";
        sha256 = "16g0w09h3bqmas4hy1m0y6j5ffyharslw52fn25gql57bfihg7ym";
      })
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.1/Prod/patches/3/cuda_9.1.85.3_linux";
        sha256 = "12mcv6f8z33z8y41ja8bv5p5iqhv2vx91mv3b5z6fcj7iqv98422";
      })
    ];
    gcc = gcc6;
  };

  cudatoolkit_9_2 = common {
    version = "9.2.148.1";
    url = "https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux";
    sha256 = "04c6v9b50l4awsf9w9zj5vnxvmc0hk0ypcfjksbh4vnzrz14wigm";
    runPatches = [
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.2/Prod2/patches/1/cuda_9.2.148.1_linux";
        sha256 = "1kx6l4yzsamk6q1f4vllcpywhbfr2j5wfl4h5zx8v6dgfpsjm2lw";
      })
    ];
    gcc = gcc7;
  };

  cudatoolkit_9 = cudatoolkit_9_2;

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

  cudatoolkit_11 = cudatoolkit_11_2;
}
