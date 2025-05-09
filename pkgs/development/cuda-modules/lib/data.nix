{ cudaLib, lib }:
{
  /**
    The path to the CUDA packages root directory, for use with `callPackage` to create new package sets.

    # Type

    ```
    cudaPackagesPath :: Path
    ```
  */
  cudaPackagesPath = ./..;

  /**
    A list of redistributable systems to use in creation of the `redistSystem` option type.

    # Type

    ```
    redistSystems :: [String]
    ```
  */
  redistSystems = [
    "linux-aarch64"
    "linux-all" # Taken to mean all other linux systems
    "linux-sbsa"
    "linux-x86_64"
    "source" # Source-agnostic platform
  ];

  /**
    A list of redistributable names to use in creation of the `redistName` option type.

    # Type

    ```
    redistNames :: [String]
    ```
  */
  redistNames = [
    "cublasmp"
    "cuda"
    "cudnn"
    "cudss"
    "cuquantum"
    "cusolvermp"
    "cusparselt"
    "cutensor"
    "nppplus"
    "nvcomp"
    # "nvidia-driver",  # NOTE: Some of the earlier manifests don't follow our scheme.
    "nvjpeg2000"
    "nvpl"
    "nvtiff"
    "tensorrt" # NOTE: not truly a redist; uses different naming convention
  ];

  /**
    The prefix of the URL for redistributable files.

    # Type

    ```
    redistUrlPrefix :: String
    ```
  */
  redistUrlPrefix = "https://developer.download.nvidia.com/compute";

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
        # Tesla K40
        "3.5" = {
          archName = "Kepler";
          minCudaMajorMinorVersion = "10.0";
          dontDefaultAfterCudaMajorMinorVersion = "11.0";
          maxCudaMajorMinorVersion = "11.8";
        };

        # Tesla K80
        "3.7" = {
          archName = "Kepler";
          minCudaMajorMinorVersion = "10.0";
          dontDefaultAfterCudaMajorMinorVersion = "11.0";
          maxCudaMajorMinorVersion = "11.8";
        };

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

        # Jetson AGX Xavier, Drive AGX Pegasus, Xavier NX
        "7.2" = {
          archName = "Volta";
          minCudaMajorMinorVersion = "10.0";
          # Note: without `cuda_compat`, maxCudaMajorMinorVersion is 11.8
          # https://docs.nvidia.com/cuda/cuda-for-tegra-appnote/index.html#deployment-considerations-for-cuda-upgrade-package
          maxCudaMajorMinorVersion = "12.2";
          isJetson = true;
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

  /**
    All CUDA capabilities, sorted by version.

    NOTE: Since the capabilities are sorted by version and architecture/family-specific features are
    appended to the minor version component, the sorted list groups capabilities by baseline feature
    set.

    # Type

    ```
    allSortedCudaCapabilities :: [CudaCapability]
    ```

    # Example

    ```
    allSortedCudaCapabilities = [
      "5.0"
      "5.2"
      "6.0"
      "6.1"
      "7.0"
      "7.2"
      "7.5"
      "8.0"
      "8.6"
      "8.7"
      "8.9"
      "9.0"
      "9.0a"
      "10.0"
      "10.0a"
      "10.0f"
      "10.1"
      "10.1a"
      "10.1f"
      "10.3"
      "10.3a"
      "10.3f"
    ];
    ```
  */
  allSortedCudaCapabilities = lib.sort lib.versionOlder (
    lib.attrNames cudaLib.data.cudaCapabilityToInfo
  );

  /**
    Mapping of CUDA micro-architecture name to capabilities belonging to that micro-architecture.

    # Type

    ```
    cudaArchNameToCapabilities :: AttrSet NonEmptyStr (NonEmptyListOf CudaCapability)
    ```
  */
  cudaArchNameToCapabilities = lib.groupBy (
    cudaCapability: cudaLib.data.cudaCapabilityToInfo.${cudaCapability}.archName
  ) cudaLib.data.allSortedCudaCapabilities;

  /**
    Mapping of CUDA versions to NVCC compatibilities

    Taken from
    https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#host-compiler-support-policy

      NVCC performs a version check on the host compiler's major version and so newer minor versions
      of the compilers listed below will be supported, but major versions falling outside the range
      will not be supported.

    NOTE: These constraints don't apply to Jetson, which uses something else.

    NOTE: NVIDIA can and will add support for newer compilers even during patch releases.
    E.g.: CUDA 12.2.1 maxxed out with support for Clang 15.0; 12.2.2 added support for Clang 16.0.

    NOTE: Because all platforms NVIDIA supports use GCC and Clang, we omit the architectures here.

    # Type

    ```
    nvccCompatibilities ::
      AttrSet
        String
        { clang :: { maxMajorVersion :: String, minMajorVersion :: String }
        , gcc :: { maxMajorVersion :: String, minMajorVersion :: String }
        }
    ```
  */
  nvccCompatibilities = {
    # Our baseline
    # https://docs.nvidia.com/cuda/archive/11.0/cuda-toolkit-release-notes/index.html#cuda-compiler-new-features
    "11.0" = {
      clang = {
        maxMajorVersion = "9";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "9";
        minMajorVersion = "6";
      };
    };

    # Added support for Clang 10 and GCC 10
    # https://docs.nvidia.com/cuda/archive/11.1.1/cuda-toolkit-release-notes/index.html#cuda-compiler-new-features
    "11.1" = {
      clang = {
        maxMajorVersion = "10";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "10";
        minMajorVersion = "6";
      };
    };

    # Added support for Clang 11
    # https://docs.nvidia.com/cuda/archive/11.2.2/cuda-installation-guide-linux/index.html#system-requirements
    "11.2" = {
      clang = {
        maxMajorVersion = "11";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "10";
        minMajorVersion = "6";
      };
    };

    # No changes from 11.2 to 11.3
    "11.3" = {
      clang = {
        maxMajorVersion = "11";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "10";
        minMajorVersion = "6";
      };
    };

    # Added support for Clang 12 and GCC 11
    # https://docs.nvidia.com/cuda/archive/11.4.4/cuda-toolkit-release-notes/index.html#cuda-general-new-features
    # NOTE: There is a bug in the version of GLIBC that GCC 11 uses which causes it to fail to compile some CUDA
    # code. As such, we skip it for this release, and do the bump in 11.6 (skipping 11.5).
    # https://forums.developer.nvidia.com/t/cuda-11-5-samples-throw-multiple-error-attribute-malloc-does-not-take-arguments/192750/15
    "11.4" = {
      clang = {
        maxMajorVersion = "12";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "10";
        minMajorVersion = "6";
      };
    };

    # No changes from 11.4 to 11.5
    "11.5" = {
      clang = {
        maxMajorVersion = "12";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "10";
        minMajorVersion = "6";
      };
    };

    # No changes from 11.5 to 11.6
    # However, as mentioned above, we add GCC 11 this release.
    "11.6" = {
      clang = {
        maxMajorVersion = "12";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "11";
        minMajorVersion = "6";
      };
    };

    # Added support for Clang 13
    # https://docs.nvidia.com/cuda/archive/11.7.1/cuda-toolkit-release-notes/index.html#cuda-compiler-new-features
    "11.7" = {
      clang = {
        maxMajorVersion = "13";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "11";
        minMajorVersion = "6";
      };
    };

    # Added support for Clang 14
    # https://docs.nvidia.com/cuda/archive/11.8.0/cuda-installation-guide-linux/index.html#system-requirements
    "11.8" = {
      clang = {
        maxMajorVersion = "14";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "11";
        minMajorVersion = "6";
      };
    };

    # Added support for GCC 12
    # https://docs.nvidia.com/cuda/archive/12.0.1/cuda-installation-guide-linux/index.html#system-requirements
    "12.0" = {
      clang = {
        maxMajorVersion = "14";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "12";
        minMajorVersion = "6";
      };
    };

    # Added support for Clang 15
    # https://docs.nvidia.com/cuda/archive/12.1.1/cuda-toolkit-release-notes/index.html#cuda-compilers-new-features
    "12.1" = {
      clang = {
        maxMajorVersion = "15";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "12";
        minMajorVersion = "6";
      };
    };

    # Added support for Clang 16
    # https://docs.nvidia.com/cuda/archive/12.2.2/cuda-installation-guide-linux/index.html#host-compiler-support-policy
    "12.2" = {
      clang = {
        maxMajorVersion = "16";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "12";
        minMajorVersion = "6";
      };
    };

    # No changes from 12.2 to 12.3
    # https://docs.nvidia.com/cuda/archive/12.3.2/cuda-installation-guide-linux/index.html#host-compiler-support-policy
    "12.3" = {
      clang = {
        maxMajorVersion = "16";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "12";
        minMajorVersion = "6";
      };
    };

    # Maximum Clang version is 17
    # Minimum GCC version is still 6, but all versions prior to GCC 7.3 are deprecated.
    # Maximum GCC version is 13.2
    # https://docs.nvidia.com/cuda/archive/12.4.1/cuda-installation-guide-linux/index.html#host-compiler-support-policy
    "12.4" = {
      clang = {
        maxMajorVersion = "17";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "13";
        minMajorVersion = "6";
      };
    };

    # No changes from 12.4 to 12.5
    # https://docs.nvidia.com/cuda/archive/12.5.1/cuda-installation-guide-linux/index.html#host-compiler-support-policy
    "12.5" = {
      clang = {
        maxMajorVersion = "17";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "13";
        minMajorVersion = "6";
      };
    };

    # Maximum Clang version is 18
    # https://docs.nvidia.com/cuda/archive/12.6.0/cuda-installation-guide-linux/index.html#host-compiler-support-policy
    "12.6" = {
      clang = {
        maxMajorVersion = "18";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "13";
        minMajorVersion = "6";
      };
    };

    # Maximum Clang version is 19, maximum GCC version is 14
    # https://docs.nvidia.com/cuda/archive/12.8.1/cuda-installation-guide-linux/index.html#host-compiler-support-policy
    "12.8" = {
      clang = {
        maxMajorVersion = "19";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "14";
        minMajorVersion = "6";
      };
    };

    # No changes from 12.8 to 12.9
    # https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#host-compiler-support-policy
    "12.9" = {
      clang = {
        maxMajorVersion = "19";
        minMajorVersion = "7";
      };
      gcc = {
        maxMajorVersion = "14";
        minMajorVersion = "6";
      };
    };
  };
}
