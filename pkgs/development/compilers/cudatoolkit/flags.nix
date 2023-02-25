{ config
, lib
, cudatoolkit
}:

# Type aliases
# Gpu = {
#   archName: String, # e.g., "Hopper"
#   computeCapability: String, # e.g., "9.0"
#   minCudaVersion: String, # e.g., "11.8"
#   maxCudaVersion: String, # e.g., "12.0"
# }

let
  inherit (lib) attrsets lists strings trivial versions;
  cudaVersion = cudatoolkit.version;

  # Flags are determined based on your CUDA toolkit by default.  You may benefit
  # from improved performance, reduced file size, or greater hardware suppport by
  # passing a configuration based on your specific GPU environment.
  #
  # config.cudaCapabilities: list of hardware generations to support (e.g., "8.0")
  # config.cudaForwardCompat: bool for compatibility with future GPU generations
  #
  # Please see the accompanying documentation or https://github.com/NixOS/nixpkgs/pull/205351

  # gpus :: List Gpu
  gpus = builtins.import ./gpus.nix;

  # isVersionIn :: Gpu -> Bool
  isSupported = gpu:
    let
      inherit (gpu) minCudaVersion maxCudaVersion;
      lowerBoundSatisfied = strings.versionAtLeast cudaVersion minCudaVersion;
      upperBoundSatisfied = !(strings.versionOlder maxCudaVersion cudaVersion);
    in
    lowerBoundSatisfied && upperBoundSatisfied;

  # supportedGpus :: List Gpu
  # GPUs which are supported by the provided CUDA version.
  supportedGpus = builtins.filter isSupported gpus;

  # cudaArchNameToVersions :: AttrSet String (List String)
  # Maps the name of a GPU architecture to different versions of that architecture.
  # For example, "Ampere" maps to [ "8.0" "8.6" "8.7" ].
  cudaArchNameToVersions =
    lists.groupBy'
      (versions: gpu: versions ++ [ gpu.computeCapability ])
      [ ]
      (gpu: gpu.archName)
      supportedGpus;

  # cudaArchNames :: List String
  # NOTE: It's important that we don't rely on builtins.attrNames cudaArchNameToVersions here;
  #   otherwise, we'll get the names sorted in alphabetical order. The JSON array we read them
  #   from is already sorted, so we'll preserve that order here.
  cudaArchNames = lists.unique (lists.map (gpu: gpu.archName) supportedGpus);

  # cudaComputeCapabilityToName :: AttrSet String String
  # Maps the version of a GPU architecture to the name of that architecture.
  # For example, "8.0" maps to "Ampere".
  cudaComputeCapabilityToName = builtins.listToAttrs (
    lists.map
      (gpu: {
        name = gpu.computeCapability;
        value = gpu.archName;
      })
      supportedGpus
  );

  # cudaComputeCapabilities :: List String
  # NOTE: It's important that we don't rely on builtins.attrNames cudaComputeCapabilityToName here;
  #   otherwise, we'll get the versions sorted in alphabetical order. The JSON array we read them
  #   from is already sorted, so we'll preserve that order here.
  # Use the user-provided list of CUDA capabilities if it's provided.
  cudaComputeCapabilities = config.cudaCapabilities
    or (lists.map (gpu: gpu.computeCapability) supportedGpus);

  # cudaForwardComputeCapability :: String
  cudaForwardComputeCapability = (lists.last cudaComputeCapabilities) + "+PTX";

  # cudaComputeCapabilitiesAndForward :: List String
  # The list of supported CUDA architectures, including the forward compatibility architecture.
  # If forward compatibility is disabled, this will be the same as cudaComputeCapabilities.
  cudaComputeCapabilitiesAndForward = cudaComputeCapabilities
    ++ lists.optional (config.cudaForwardCompat or true) cudaForwardComputeCapability;

  # dropDot :: String -> String
  dropDot = ver: builtins.replaceStrings [ "." ] [ "" ] ver;

  # archMapper :: String -> List String -> List String
  # Maps a feature across a list of architecture versions to produce a list of architectures.
  # For example, "sm" and [ "8.0" "8.6" "8.7" ] produces [ "sm_80" "sm_86" "sm_87" ].
  archMapper = feat: lists.map (computeCapability: "${feat}_${dropDot computeCapability}");

  # gencodeMapper :: String -> List String -> List String
  # Maps a feature across a list of architecture versions to produce a list of gencode arguments.
  # For example, "sm" and [ "8.0" "8.6" "8.7" ] produces [ "-gencode=arch=compute_80,code=sm_80"
  # "-gencode=arch=compute_86,code=sm_86" "-gencode=arch=compute_87,code=sm_87" ].
  gencodeMapper = feat: lists.map (
    computeCapability:
    "-gencode=arch=compute_${dropDot computeCapability},code=${feat}_${dropDot computeCapability}"
  );

  # cudaRealArches :: List String
  # The real architectures are physical architectures supported by the CUDA version.
  # For example, "sm_80".
  cudaRealArches = archMapper "sm" cudaComputeCapabilities;

  # cudaVirtualArches :: List String
  # The virtual architectures are typically used for forward compatibility, when trying to support
  # an architecture newer than the CUDA version allows.
  # For example, "compute_80".
  cudaVirtualArches = archMapper "compute" cudaComputeCapabilities;

  # cudaArches :: List String
  # By default, build for all supported architectures and forward compatibility via a virtual
  # architecture for the newest supported architecture.
  cudaArches = cudaRealArches ++
    lists.optional (config.cudaForwardCompat or true) (lists.last cudaVirtualArches);

  # cudaGencode :: List String
  # A list of CUDA gencode arguments to pass to NVCC.
  cudaGencode =
    let
      base = gencodeMapper "sm" cudaComputeCapabilities;
      forwardCompat = gencodeMapper "compute" [ (lists.last cudaComputeCapabilities) ];
    in
    base ++ lists.optionals (config.cudaForwardCompat or true) forwardCompat;

in
{
  inherit
    cudaArchNames
    cudaArchNameToVersions cudaComputeCapabilityToName
    cudaRealArches cudaVirtualArches cudaArches
    cudaGencode;
  cudaCapabilities = cudaComputeCapabilitiesAndForward;
}
