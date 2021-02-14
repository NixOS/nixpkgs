{ callPackage, cudatoolkit_9_0, cudatoolkit_9_1, cudatoolkit_9_2, cudatoolkit_10_0, cudatoolkit_10_1, cudatoolkit_10_2, cudatoolkit_11_0, cudatoolkit_11_1, cudatoolkit_11_2 }:

let
  generic = args: callPackage (import ./generic.nix (removeAttrs args ["cudatoolkit"])) {
    inherit (args) cudatoolkit;
  };

in rec {
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

  cudnn_cudatoolkit_10 = cudnn_cudatoolkit_10_2;

  cudnn_cudatoolkit_11_0 = generic rec {
    version = "8.1.0";
    cudatoolkit = cudatoolkit_11_0;
    # 8.1.0 is compatible with CUDA 11.0, 11.1, and 11.2:
    # https://docs.nvidia.com/deeplearning/cudnn/support-matrix/index.html#cudnn-cuda-hardware-versions
    srcName = "cudnn-11.2-linux-x64-v8.1.0.77.tgz";
    sha256 = "sha256-2+gvrwcdkbqbzwBIAUatM/RiSC3+5WyvRHnBuNq+Pss=";
  };

  cudnn_cudatoolkit_11_1 = cudnn_cudatoolkit_11_0.override {
    cudatoolkit = cudatoolkit_11_1;
  };

  cudnn_cudatoolkit_11_2 = cudnn_cudatoolkit_11_0.override {
    cudatoolkit = cudatoolkit_11_2;
  };

  cudnn_cudatoolkit_11 = cudnn_cudatoolkit_11_2;
}
