{ callPackage, cudatoolkit_7, cudatoolkit_7_5, cudatoolkit_8, cudatoolkit_9_0, cudatoolkit_9_1, cudatoolkit_9_2, cudatoolkit_10_0, cudatoolkit_10_1, cudatoolkit_10_2 }:

let
  generic = args: callPackage (import ./generic.nix (removeAttrs args ["cudatoolkit"])) {
    inherit (args) cudatoolkit;
  };

in rec {
  cudnn_cudatoolkit_7 = generic rec {
    # Old URL is v4 instead of v4.0 for some reason...
    version = "4";
    cudatoolkit = cudatoolkit_7;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v4.0-prod.tgz";
    sha256 = "01a4v5j4v9n2xjqcc4m28c3m67qrvsx87npvy7zhx7w8smiif2fd";
  };

  cudnn_cudatoolkit_7_5 = generic rec {
    version = "6.0";
    cudatoolkit = cudatoolkit_7_5;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v${version}.tgz";
    sha256 = "0b68hv8pqcvh7z8xlgm4cxr9rfbjs0yvg1xj2n5ap4az1h3lp3an";
  };

  cudnn6_cudatoolkit_8 = generic rec {
    version = "6.0";
    cudatoolkit = cudatoolkit_8;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v${version}.tgz";
    sha256 = "173zpgrk55ri8if7s5yngsc89ajd6hz4pss4cdxlv6lcyh5122cv";
  };

  cudnn_cudatoolkit_8 = generic rec {
    version = "7.0.5";
    cudatoolkit = cudatoolkit_8;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v7.tgz";
    sha256 = "9e0b31735918fe33a79c4b3e612143d33f48f61c095a3b993023cdab46f6d66e";
  };

  cudnn_cudatoolkit_9_0 = generic rec {
    version = "7.3.0";
    cudatoolkit = cudatoolkit_9_0;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v7.3.0.29.tgz";
    sha256 = "16z4vgbcmbayk4hppz0xshgs3g07blkp4j25cxcjqyrczx1r0gs0";
  };

  cudnn_cudatoolkit_9_1 = generic rec {
    version = "7.1.3";
    cudatoolkit = cudatoolkit_9_1;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v7.1.tgz";
    sha256 = "0a0237gpr0p63s92njai0xvxmkbailzgfsvh7n9fnz0njhvnsqfx";
  };

  cudnn_cudatoolkit_9_2 = generic rec {
    version = "7.2.1";
    cudatoolkit = cudatoolkit_9_2;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v7.2.1.38.tgz";
    sha256 = "1sf215wm6zgr17gs6sxfhw61b7a0qmcxiwhgy1b4nqdyxpqgay1y";
  };

  cudnn_cudatoolkit_9 = cudnn_cudatoolkit_9_2;

  cudnn_cudatoolkit_10_0 = generic rec {
    version = "7.4.2";
    cudatoolkit = cudatoolkit_10_0;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v7.4.2.24.tgz";
    sha256 = "18ys0apiz9afid2s6lvy9qbyi8g66aimb2a7ikl1f3dm09mciprf";
  };

  cudnn_cudatoolkit_10_1 = generic rec {
    version = "7.6.3";
    cudatoolkit = cudatoolkit_10_1;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v7.6.3.30.tgz";
    sha256 = "0qc9f1xpyfibwqrpqxxq2v9h6w90j0dbx564akwy44c1dls5f99m";
  };

  cudnn_cudatoolkit_10_2 = generic rec {
    version = "7.6.5";
    cudatoolkit = cudatoolkit_10_2;
    srcName = "cudnn-${cudatoolkit.majorVersion}-linux-x64-v7.6.5.32.tgz";
    sha256 = "084c13vzjdkb5s1996yilybg6dgav1lscjr1xdcgvlmfrbr6f0k0";
  };

  cudnn_cudatoolkit_10 = cudnn_cudatoolkit_10_1;
}
