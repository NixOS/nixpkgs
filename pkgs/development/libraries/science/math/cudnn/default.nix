# The following version combinations are supported:
#  * cuDNN 7.4.2, cudatoolkit 10.0
#  * cuDNN 7.6.5, cudatoolkit 10.0-10.1
#  * cuDNN 8.1.1, cudatoolkit 10.2-11.2
#  * cuDNN 8.3.2, cudatoolkit 10.2-11.5
{ callPackage
, cudatoolkit_10
, cudatoolkit_10_0
, cudatoolkit_10_1
, cudatoolkit_10_2
, cudatoolkit_11
, cudatoolkit_11_0
, cudatoolkit_11_1
, cudatoolkit_11_2
, cudatoolkit_11_3
, cudatoolkit_11_4
, cudatoolkit_11_5
, fetchurl
, lib
}:

let
  generic = args: callPackage (import ./generic.nix (removeAttrs args [ "cudatoolkit" ])) {
    inherit (args) cudatoolkit;
  };
  urlPrefix = "https://developer.download.nvidia.com/compute/redist/cudnn";
in
rec {
  # cuDNN 7.x
  # Still used by libtensorflow-bin. It should be upgraded at some point.
  cudnn_7_4_cudatoolkit_10_0 = generic rec {
    version = "7.4.2";
    cudatoolkit = cudatoolkit_10_0;
    # See https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn_742/cudnn-support-matrix/index.html#cudnn-cuda-hardware-versions__table-cudnn-cuda-hardware-versions.
    minCudaVersion = "9.2.88";
    maxCudaVersion = "10.0.99999";
    mkSrc = _: fetchurl {
      url = "${urlPrefix}/v${version}/cudnn-10.0-linux-x64-v7.4.2.24.tgz";
      hash = "sha256-Lt/IagK1DRfojEeJVaMy5qHoF05+U6NFi06lH68C2qM=";
    };
  };
  # The only overlap between supported and packaged CUDA versions is 10.0.

  cudnn_7_6_cudatoolkit_10_0 = generic rec {
    version = "7.6.5";
    cudatoolkit = cudatoolkit_10_0;
    # See https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn_765/cudnn-support-matrix/index.html#cudnn-versions-763-765.
    minCudaVersion = "9.2.148";
    maxCudaVersion = "10.1.243";
    mkSrc = cudatoolkit: fetchurl {
      url = "${urlPrefix}/v${version}/cudnn-${cudatoolkit.majorVersion}-linux-x64-v7.6.5.32.tgz";
      hash = {
        "10.0" = "sha256-KDVeOV8LK5OsLIO2E2CzW6bNA3fkTni+GXtrYbS0kro=";
        "10.1" = "sha256-fq7IA5osMKsLx1jTA1iHZ2k972v0myJIWiwAvy4TbLM=";
      }."${cudatoolkit.majorVersion}";
    };
  };
  cudnn_7_6_cudatoolkit_10_1 = cudnn_7_6_cudatoolkit_10_0.override { cudatoolkit = cudatoolkit_10_1; };

  # cuDNN 8.x
  # cuDNN 8.1 is still used by tensorflow at the time of writing (2022-02-17).
  # See https://github.com/NixOS/nixpkgs/pull/158218 for more info.
  cudnn_8_1_cudatoolkit_10_2 = generic rec {
    version = "8.1.1";
    cudatoolkit = cudatoolkit_10_2;
    # See https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-811/support-matrix/index.html#cudnn-versions-810-811.
    minCudaVersion = "10.2.00000";
    maxCudaVersion = "11.2.99999";
    mkSrc = cudatoolkit:
      let v = if lib.versions.majorMinor cudatoolkit.version == "10.2" then "10.2" else "11.2"; in
      fetchurl {
        url = "${urlPrefix}/v${version}/cudnn-${v}-linux-x64-v8.1.1.33.tgz";
        hash = {
          "10.2" = "sha256-Kkp7mabpv6aQ6xm7QeSVU/KnpJGls6v8rpAOFmxbbr0=";
          "11.2" = "sha256-mKh4TpKGLyABjSDCgbMNSgzZUfk2lPZDPM9K6cUCumo=";
        }."${v}";
      };
  };
  cudnn_8_1_cudatoolkit_11_0 = cudnn_8_1_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_11_0; };
  cudnn_8_1_cudatoolkit_11_1 = cudnn_8_1_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_11_1; };
  cudnn_8_1_cudatoolkit_11_2 = cudnn_8_1_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_11_2; };

  cudnn_8_1_cudatoolkit_10 = cudnn_8_1_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_10; };

  # cuDNN 8.3 is necessary for the latest jaxlib, esp. jaxlib-bin. See
  # https://github.com/google/jax/discussions/9455 for more info.
  cudnn_8_3_cudatoolkit_10_2 = generic rec {
    version = "8.3.2";
    cudatoolkit = cudatoolkit_10_2;
    # See https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-832/support-matrix/index.html#cudnn-cuda-hardware-versions.
    minCudaVersion = "10.2.00000";
    maxCudaVersion = "11.5.99999";
    mkSrc = cudatoolkit:
      let v = if lib.versions.majorMinor cudatoolkit.version == "10.2" then "10.2" else "11.5"; in
      fetchurl {
        # Starting at version 8.3.1 there's a new directory layout including
        # a subdirectory `local_installers`.
        url = "https://developer.download.nvidia.com/compute/redist/cudnn/v${version}/local_installers/${v}/cudnn-linux-x86_64-8.3.2.44_cuda${v}-archive.tar.xz";
        hash = {
          "10.2" = "sha256-1vVu+cqM+PketzIQumw9ykm6REbBZhv6/lXB7EC2aaw=";
          "11.5" = "sha256-VQCVPAjF5dHd3P2iNPnvvdzb5DpTsm3AqCxyP6FwxFc=";
        }."${v}";
      };
  };
  cudnn_8_3_cudatoolkit_11_0 = cudnn_8_3_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_11_0; };
  cudnn_8_3_cudatoolkit_11_1 = cudnn_8_3_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_11_1; };
  cudnn_8_3_cudatoolkit_11_2 = cudnn_8_3_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_11_2; };
  cudnn_8_3_cudatoolkit_11_3 = cudnn_8_3_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_11_3; };
  cudnn_8_3_cudatoolkit_11_4 = cudnn_8_3_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_11_4; };
  cudnn_8_3_cudatoolkit_11_5 = cudnn_8_3_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_11_5; };

  cudnn_8_3_cudatoolkit_10 = cudnn_8_3_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_10; };
  cudnn_8_3_cudatoolkit_11 = cudnn_8_3_cudatoolkit_10_2.override { cudatoolkit = cudatoolkit_11; };
}
