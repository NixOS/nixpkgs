{
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
