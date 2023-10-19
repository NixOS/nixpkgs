[
  # Type alias
  # Gpu = {
  #   archName: String
  #     - The name of the microarchitecture.
  #   computeCapability: String
  #     - The compute capability of the GPU.
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
  {
    archName = "Kepler";
    computeCapability = "3.0";
    minCudaVersion = "10.0";
    dontDefaultAfter = "10.2";
    maxCudaVersion = "10.2";
  }
  {
    archName = "Kepler";
    computeCapability = "3.2";
    minCudaVersion = "10.0";
    dontDefaultAfter = "10.2";
    maxCudaVersion = "10.2";
  }
  {
    archName = "Kepler";
    computeCapability = "3.5";
    minCudaVersion = "10.0";
    dontDefaultAfter = "11.0";
    maxCudaVersion = "11.8";
  }
  {
    archName = "Kepler";
    computeCapability = "3.7";
    minCudaVersion = "10.0";
    dontDefaultAfter = "11.0";
    maxCudaVersion = "11.8";
  }
  {
    archName = "Maxwell";
    computeCapability = "5.0";
    minCudaVersion = "10.0";
    dontDefaultAfter = "11.0";
    maxCudaVersion = null;
  }
  {
    archName = "Maxwell";
    computeCapability = "5.2";
    minCudaVersion = "10.0";
    dontDefaultAfter = "11.0";
    maxCudaVersion = null;
  }
  {
    archName = "Maxwell";
    computeCapability = "5.3";
    minCudaVersion = "10.0";
    dontDefaultAfter = "11.0";
    maxCudaVersion = null;
  }
  {
    archName = "Pascal";
    computeCapability = "6.0";
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    archName = "Pascal";
    computeCapability = "6.1";
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    archName = "Pascal";
    computeCapability = "6.2";
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    archName = "Volta";
    computeCapability = "7.0";
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    archName = "Volta";
    computeCapability = "7.2";
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    archName = "Turing";
    computeCapability = "7.5";
    minCudaVersion = "10.0";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    archName = "Ampere";
    computeCapability = "8.0";
    minCudaVersion = "11.2";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    archName = "Ampere";
    computeCapability = "8.6";
    minCudaVersion = "11.2";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    archName = "Ampere";
    computeCapability = "8.7";
    minCudaVersion = "11.5";
    # NOTE: This is purposefully before 11.5 to ensure it is never a capability we target by
    #   default. 8.7 is the Jetson Orin series of devices which are a very specific platform.
    #   We keep this entry here in case we ever want to target it explicitly, but we don't
    #   want to target it by default.
    dontDefaultAfter = "11.4";
    maxCudaVersion = null;
  }
  {
    archName = "Ada";
    computeCapability = "8.9";
    minCudaVersion = "11.8";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
  {
    archName = "Hopper";
    computeCapability = "9.0";
    minCudaVersion = "11.8";
    dontDefaultAfter = null;
    maxCudaVersion = null;
  }
]
