# Taken from
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#host-compiler-support-policy
#
#   NVCC performs a version check on the host compiler’s major version and so newer minor versions
#   of the compilers listed below will be supported, but major versions falling outside the range
#   will not be supported.
#
# NOTE: These constraints don't apply to Jetson, which uses something else.
# NOTE: NVIDIA can and will add support for newer compilers even during patch releases.
# E.g.: CUDA 12.2.1 maxxed out with support for Clang 15.0; 12.2.2 added support for Clang 16.0.
# NOTE: Because all platforms NVIDIA supports use GCC and Clang, we omit the architectures here.
# Type Aliases
# CudaVersion = String (two-part version number, e.g. "11.2")
# Platform = String (e.g. "x86_64-linux")
# CompilerCompatibilities = {
#  clangMaxMajorVersion = String (e.g. "15")
#  clangMinMajorVersion = String (e.g. "7")
#  gccMaxMajorVersion = String (e.g. "11")
#  gccMinMajorVersion = String (e.g. "6")
# }
let
  # attrs :: AttrSet CudaVersion CompilerCompatibilities
  attrs = {
    # Our baseline
    # https://docs.nvidia.com/cuda/archive/10.0/cuda-toolkit-release-notes/index.html#cuda-compiler-new-features
    "10.0" = {
      clangMaxMajorVersion = "6";
      clangMinMajorVersion = "6";
      gccMaxMajorVersion = "7";
      gccMinMajorVersion = "5";
    };

    # Added support for Clang 7 and GCC 8
    # https://docs.nvidia.com/cuda/archive/10.1/cuda-toolkit-release-notes/index.html#cuda-compiler-new-features
    "10.1" = attrs."10.0" // {
      clangMaxMajorVersion = "7";
      gccMaxMajorVersion = "8";
    };

    # Added clang 8
    # https://docs.nvidia.com/cuda/archive/10.2/cuda-toolkit-release-notes/index.html#cuda-compiler-new-features
    "10.2" = attrs."10.1" // {
      clangMaxMajorVersion = "8";
    };

    # Added support for Clang 9 and GCC 9
    # https://docs.nvidia.com/cuda/archive/11.0/cuda-toolkit-release-notes/index.html#cuda-compiler-new-features
    "11.0" = {
      clangMaxMajorVersion = "9";
      clangMinMajorVersion = "7";
      gccMaxMajorVersion = "9";
      gccMinMajorVersion = "6";
    };

    # Added support for Clang 10 and GCC 10
    # https://docs.nvidia.com/cuda/archive/11.1.1/cuda-toolkit-release-notes/index.html#cuda-compiler-new-features
    "11.1" = attrs."11.0" // {
      clangMaxMajorVersion = "10";
      gccMaxMajorVersion = "10";
    };

    # Added support for Clang 11
    # https://docs.nvidia.com/cuda/archive/11.2.2/cuda-installation-guide-linux/index.html#system-requirements
    "11.2" = attrs."11.1" // {
      clangMaxMajorVersion = "11";
    };

    # No changes from 11.2 to 11.3
    "11.3" = attrs."11.2";

    # Added support for Clang 12 and GCC 11
    # https://docs.nvidia.com/cuda/archive/11.4.4/cuda-toolkit-release-notes/index.html#cuda-general-new-features
    "11.4" = attrs."11.3" // {
      clangMaxMajorVersion = "12";
      # NOTE: There is a bug in the version of GLIBC that GCC 11 uses which causes it to fail to compile some CUDA
      # code. As such, we skip it for this release, and do the bump in 11.6 (skipping 11.5).
      # https://forums.developer.nvidia.com/t/cuda-11-5-samples-throw-multiple-error-attribute-malloc-does-not-take-arguments/192750/15
      # gccMaxMajorVersion = "11";
    };

    # No changes from 11.4 to 11.5
    "11.5" = attrs."11.4";

    # No changes from 11.5 to 11.6
    # However, as mentioned above, we add GCC 11 this release.
    "11.6" = attrs."11.5" // {
      gccMaxMajorVersion = "11";
    };

    # Added support for Clang 13
    # https://docs.nvidia.com/cuda/archive/11.7.1/cuda-toolkit-release-notes/index.html#cuda-compiler-new-features
    "11.7" = attrs."11.6" // {
      clangMaxMajorVersion = "13";
    };

    # Added support for Clang 14
    # https://docs.nvidia.com/cuda/archive/11.8.0/cuda-installation-guide-linux/index.html#system-requirements
    "11.8" = attrs."11.7" // {
      clangMaxMajorVersion = "14";
    };

    # Added support for GCC 12
    # https://docs.nvidia.com/cuda/archive/12.0.1/cuda-installation-guide-linux/index.html#system-requirements
    "12.0" = attrs."11.8" // {
      gccMaxMajorVersion = "12";
    };

    # Added support for Clang 15
    # https://docs.nvidia.com/cuda/archive/12.1.1/cuda-toolkit-release-notes/index.html#cuda-compilers-new-features
    "12.1" = attrs."12.0" // {
      clangMaxMajorVersion = "15";
    };

    # Added support for Clang 16
    # https://docs.nvidia.com/cuda/archive/12.2.2/cuda-installation-guide-linux/index.html#host-compiler-support-policy
    "12.2" = attrs."12.1" // {
      clangMaxMajorVersion = "16";
    };

    # No changes from 12.2 to 12.3
    "12.3" = attrs."12.2";

    # No changes from 12.2 to 12.3
    "12.4" = attrs."12.3" // {
      clangMaxMajorVersion = "17";
      gccMaxMajorVersion = "13";
    };
  };
in
attrs
