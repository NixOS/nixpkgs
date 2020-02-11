{ lib
, callPackage
, fetchurl
, gcc48
, gcc6
, gcc7
}:

let
  common = callPackage ./common.nix;
in rec {
  cudatoolkit_6 = common {
    version = "6.0.37";
    url = "http://developer.download.nvidia.com/compute/cuda/6_0/rel/installers/cuda_6.0.37_linux_64.run";
    sha256 = "991e436c7a6c94ec67cf44204d136adfef87baa3ded270544fa211179779bc40";
    gcc = gcc48;
  };

  cudatoolkit_6_5 = common {
    version = "6.5.19";
    url = "http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.19_linux_64.run";
    sha256 = "1x9zdmk8z784d3d35vr2ak1l4h5v4jfjhpxfi9fl9dvjkcavqyaj";
    gcc = gcc48;
  };

  cudatoolkit_7 = common {
    version = "7.0.28";
    url = "http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run";
    sha256 = "1km5hpiimx11jcazg0h3mjzk220klwahs2vfqhjavpds5ff2wafi";
    gcc = gcc6;
  };

  cudatoolkit_7_5 = common {
    version = "7.5.18";
    url = "http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run";
    sha256 = "1v2ylzp34ijyhcxyh5p6i0cwawwbbdhni2l5l4qm21s1cx9ish88";
    gcc = gcc6;
  };

  cudatoolkit_8 = common {
    version = "8.0.61.2";
    url = "https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run";
    sha256 = "1i4xrsqbad283qffvysn88w2pmxzxbbby41lw0j1113z771akv4w";
    runPatches = [
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda_8.0.61.2_linux-run";
        sha256 = "1iaz5rrsnsb1p99qiqvxn6j3ksc7ry8xlr397kqcjzxqbljbqn9d";
      })
    ];
    gcc = gcc6;
  };

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
}
