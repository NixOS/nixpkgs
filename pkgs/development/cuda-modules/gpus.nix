# Type aliases
#
# Gpu = {
#   archName: String
#     - The name of the microarchitecture.
#   computeCapability: String
#     - The compute capability of the GPU.
#   isJetson: Boolean
#     - Whether a GPU is part of NVIDIA's line of Jetson embedded computers. This field is
#       notable because it tells us what architecture to build for (as Jetson devices are
#       aarch64).
#       More on Jetson devices here:
#       https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/
#       NOTE: These architectures are only built upon request.
#   minCudaVersion: String
#     - The minimum (inclusive) CUDA version that supports this GPU.
#   dontDefaultAfter: null | String
#     - The CUDA version after which to exclude this GPU from the list of default capabilities
#       we build. null means we always include this GPU in the default capabilities if it is
#       supported.
#   maxCudaVersion: null | String
#     - The maximum (exclusive) CUDA version that supports this GPU. null means there is no
#       maximum.
# }
#
# Many thanks to Arnon Shimoni for maintaining a list of these architectures and capabilities.
# Without your work, this would have been much more difficult.
# https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/
[
  {
    # Tesla K40
    archName = "Kepler";
    computeCapability = "3.5";
    isJetson = false;
    minCudaVersion = "10.0";
    dontDefaultAfter = "11.0";
    maxCudaVersion = "11.8";
  }
  {
    # Tesla K80
    archName = "Kepler";
    computeCapability = "3.7";
    isJetson = false;
    minCudaVersion = "10.0";
    dontDefaultAfter = "11.0";
    maxCudaVersion = "11.8";
  }
  {
    # Tesla/Quadro M series
    archName = "Maxwell";
    computeCapability = "5.0";
    isJetson = false;
    minCudaVersion = "10.0";
    dontDefaultAfter = "11.0";
    maxCudaVersion = null;
  }
  {
    # Quadro M6000 , GeForce 900, GTX-970, GTX-980, GTX Titan X
    archName = "Maxwell";
    computeCapability = "5.2";
    isJetson = false;
    minCudaVersion = "10.0";
    dontDefaultAfter = "11.0";
    maxCudaVersion = null;
  }
  {
    # Tegra (Jetson) TX1 / Tegra X1, Drive CX, Drive PX, Jetson Nano
    archName = "Maxwell";
    computeCapability = "5.3";
    isJetson = true;
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # Quadro GP100, Tesla P100, DGX-1 (Generic Pascal)
    archName = "Pascal";
    computeCapability = "6.0";
    isJetson = false;
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # GTX 1080, GTX 1070, GTX 1060, GTX 1050, GTX 1030 (GP108), GT 1010 (GP108) Titan Xp, Tesla
    # P40, Tesla P4, Discrete GPU on the NVIDIA Drive PX2
    archName = "Pascal";
    computeCapability = "6.1";
    isJetson = false;
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # Integrated GPU on the NVIDIA Drive PX2, Tegra (Jetson) TX2
    archName = "Pascal";
    computeCapability = "6.2";
    isJetson = true;
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # DGX-1 with Volta, Tesla V100, GTX 1180 (GV104), Titan V, Quadro GV100
    archName = "Volta";
    computeCapability = "7.0";
    isJetson = false;
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # Jetson AGX Xavier, Drive AGX Pegasus, Xavier NX
    archName = "Volta";
    computeCapability = "7.2";
    isJetson = true;
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # GTX/RTX Turing – GTX 1660 Ti, RTX 2060, RTX 2070, RTX 2080, Titan RTX, Quadro RTX 4000,
    # Quadro RTX 5000, Quadro RTX 6000, Quadro RTX 8000, Quadro T1000/T2000, Tesla T4
    archName = "Turing";
    computeCapability = "7.5";
    isJetson = false;
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # NVIDIA A100 (the name “Tesla” has been dropped – GA100), NVIDIA DGX-A100
    archName = "Ampere";
    computeCapability = "8.0";
    isJetson = false;
    minCudaVersion = "11.2";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # Tesla GA10x cards, RTX Ampere – RTX 3080, GA102 – RTX 3090, RTX A2000, A3000, RTX A4000,
    # A5000, A6000, NVIDIA A40, GA106 – RTX 3060, GA104 – RTX 3070, GA107 – RTX 3050, RTX A10, RTX
    # A16, RTX A40, A2 Tensor Core GPU
    archName = "Ampere";
    computeCapability = "8.6";
    isJetson = false;
    minCudaVersion = "11.2";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # Jetson AGX Orin and Drive AGX Orin only
    archName = "Ampere";
    computeCapability = "8.7";
    isJetson = true;
    minCudaVersion = "11.5";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # NVIDIA GeForce RTX 4090, RTX 4080, RTX 6000, Tesla L40
    archName = "Ada";
    computeCapability = "8.9";
    isJetson = false;
    minCudaVersion = "11.8";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # NVIDIA H100 (GH100)
    archName = "Hopper";
    computeCapability = "9.0";
    isJetson = false;
    minCudaVersion = "11.8";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    # NVIDIA H100 (GH100) (Thor)
    archName = "Hopper";
    computeCapability = "9.0a";
    isJetson = false;
    minCudaVersion = "12.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
]
