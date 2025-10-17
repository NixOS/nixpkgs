{ lib }:
{

  /**
    Attribute set of supported CUDA capability mapped to information about that capability.

    NOTE: For more on baseline, architecture-specific, and family-specific feature sets, see
    https://developer.nvidia.com/blog/nvidia-blackwell-and-nvidia-cuda-12-9-introduce-family-specific-architecture-features.

    NOTE: For information on when support for a given architecture was added, see
    https://docs.nvidia.com/cuda/parallel-thread-execution/#release-notes

    NOTE: For baseline feature sets, `dontDefaultAfterCudaMajorMinorVersion` is generally set to the CUDA release
    immediately prior to TensorRT removing support for that architecture.

    Many thanks to Arnon Shimoni for maintaining a list of these architectures and capabilities.
    Without your work, this would have been much more difficult.
    https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/

    # Type

    ```
    cudaCapabilityToInfo ::
      AttrSet
        CudaCapability
        { archName :: String
        , cudaCapability :: CudaCapability
        , isJetson :: Bool
        , isArchitectureSpecific :: Bool
        , isFamilySpecific :: Bool
        , minCudaMajorMinorVersion :: MajorMinorVersion
        , maxCudaMajorMinorVersion :: MajorMinorVersion
        , dontDefaultAfterCudaMajorMinorVersion :: Null | MajorMinorVersion
        }
    ```

    `archName`

    : The name of the microarchitecture

    `cudaCapability`

    : The CUDA capability

    `isJetson`

    : Whether this capability is part of NVIDIA's line of Jetson embedded computers. This field is notable
      because it tells us what architecture to build for (as Jetson devices are aarch64).
      More on Jetson devices here: https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/
      NOTE: These architectures are only built upon request.

    `isArchitectureSpecific`

    : Whether this capability is an architecture-specific feature set.
      NOTE: These architectures are only built upon request.

    `isFamilySpecific`

    : Whether this capability is a family-specific feature set.
      NOTE: These architectures are only built upon request.

    `minCudaMajorMinorVersion`

    : The minimum (inclusive) CUDA version that supports this capability.

    `maxCudaMajorMinorVersion`

    : The maximum (exclusive) CUDA version that supports this capability.
      `null` means there is no maximum.

    `dontDefaultAfterCudaMajorMinorVersion`

    : The CUDA version after which to exclude this capability from the list of default capabilities we build.
  */
  cudaCapabilityToInfo =
    lib.mapAttrs
      (
        cudaCapability:
        # Supplies default values.
        {
          archName,
          isJetson ? false,
          isArchitectureSpecific ? (lib.hasSuffix "a" cudaCapability),
          isFamilySpecific ? (lib.hasSuffix "f" cudaCapability),
          minCudaMajorMinorVersion,
          maxCudaMajorMinorVersion ? null,
          dontDefaultAfterCudaMajorMinorVersion ? null,
        }:
        {
          inherit
            archName
            cudaCapability
            isJetson
            isArchitectureSpecific
            isFamilySpecific
            minCudaMajorMinorVersion
            maxCudaMajorMinorVersion
            dontDefaultAfterCudaMajorMinorVersion
            ;
        }
      )
      {
        # Tesla/Quadro M series
        "5.0" = {
          archName = "Maxwell";
          minCudaMajorMinorVersion = "10.0";
          dontDefaultAfterCudaMajorMinorVersion = "11.0";
        };

        # Quadro M6000 , GeForce 900, GTX-970, GTX-980, GTX Titan X
        "5.2" = {
          archName = "Maxwell";
          minCudaMajorMinorVersion = "10.0";
          dontDefaultAfterCudaMajorMinorVersion = "11.0";
        };

        # Quadro GP100, Tesla P100, DGX-1 (Generic Pascal)
        "6.0" = {
          archName = "Pascal";
          minCudaMajorMinorVersion = "10.0";
          # Removed from TensorRT 10.0, which corresponds to CUDA 12.4 release.
          # https://docs.nvidia.com/deeplearning/tensorrt/archives/tensorrt-1001/support-matrix/index.html
          dontDefaultAfterCudaMajorMinorVersion = "12.3";
        };

        # GTX 1080, GTX 1070, GTX 1060, GTX 1050, GTX 1030 (GP108), GT 1010 (GP108) Titan Xp, Tesla
        # P40, Tesla P4, Discrete GPU on the NVIDIA Drive PX2
        "6.1" = {
          archName = "Pascal";
          minCudaMajorMinorVersion = "10.0";
          # Removed from TensorRT 10.0, which corresponds to CUDA 12.4 release.
          # https://docs.nvidia.com/deeplearning/tensorrt/archives/tensorrt-1001/support-matrix/index.html
          dontDefaultAfterCudaMajorMinorVersion = "12.3";
        };

        # DGX-1 with Volta, Tesla V100, GTX 1180 (GV104), Titan V, Quadro GV100
        "7.0" = {
          archName = "Volta";
          minCudaMajorMinorVersion = "10.0";
          # Removed from TensorRT 10.5, which corresponds to CUDA 12.6 release.
          # https://docs.nvidia.com/deeplearning/tensorrt/archives/tensorrt-1050/support-matrix/index.html
          dontDefaultAfterCudaMajorMinorVersion = "12.5";
        };

        # GTX/RTX Turing – GTX 1660 Ti, RTX 2060, RTX 2070, RTX 2080, Titan RTX, Quadro RTX 4000,
        # Quadro RTX 5000, Quadro RTX 6000, Quadro RTX 8000, Quadro T1000/T2000, Tesla T4
        "7.5" = {
          archName = "Turing";
          minCudaMajorMinorVersion = "10.0";
        };

        # NVIDIA A100 (the name “Tesla” has been dropped – GA100), NVIDIA DGX-A100
        "8.0" = {
          archName = "Ampere";
          minCudaMajorMinorVersion = "11.2";
        };

        # Tesla GA10x cards, RTX Ampere – RTX 3080, GA102 – RTX 3090, RTX A2000, A3000, RTX A4000,
        # A5000, A6000, NVIDIA A40, GA106 – RTX 3060, GA104 – RTX 3070, GA107 – RTX 3050, RTX A10, RTX
        # A16, RTX A40, A2 Tensor Core GPU
        "8.6" = {
          archName = "Ampere";
          minCudaMajorMinorVersion = "11.2";
        };

        # Jetson AGX Orin and Drive AGX Orin only
        "8.7" = {
          archName = "Ampere";
          minCudaMajorMinorVersion = "11.5";
          isJetson = true;
        };

        # NVIDIA GeForce RTX 4090, RTX 4080, RTX 6000, Tesla L40
        "8.9" = {
          archName = "Ada";
          minCudaMajorMinorVersion = "11.8";
        };

        # NVIDIA H100 (GH100)
        "9.0" = {
          archName = "Hopper";
          minCudaMajorMinorVersion = "11.8";
        };

        "9.0a" = {
          archName = "Hopper";
          minCudaMajorMinorVersion = "12.0";
        };

        # NVIDIA B100
        "10.0" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.7";
        };

        "10.0a" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.7";
        };

        "10.0f" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.9";
        };

        # NVIDIA Jetson Thor Blackwell
        "10.1" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.7";
          isJetson = true;
        };

        "10.1a" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.7";
          isJetson = true;
        };

        "10.1f" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.9";
          isJetson = true;
        };

        # NVIDIA ???
        "10.3" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.9";
        };

        "10.3a" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.9";
        };

        "10.3f" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.9";
        };

        # NVIDIA GeForce RTX 5090 (GB202) etc.
        "12.0" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.8";
        };

        "12.0a" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.8";
        };

        "12.0f" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.9";
        };

        # NVIDIA ???
        "12.1" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.9";
        };

        "12.1a" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.9";
        };

        "12.1f" = {
          archName = "Blackwell";
          minCudaMajorMinorVersion = "12.9";
        };
      };
}
