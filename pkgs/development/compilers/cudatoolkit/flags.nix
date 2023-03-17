{ config
, lib
, cudaVersion
}:

# Type aliases
# Gpu :: AttrSet
#   - See the documentation in ./gpus.nix.

let
  inherit (lib) attrsets lists strings trivial versions;

  # Flags are determined based on your CUDA toolkit by default.  You may benefit
  # from improved performance, reduced file size, or greater hardware suppport by
  # passing a configuration based on your specific GPU environment.
  #
  # config.cudaCapabilities :: List Capability
  # List of hardware generations to build.
  # E.g. [ "8.0" ]
  # Currently, the last item is considered the optional forward-compatibility arch,
  # but this may change in the future.
  #
  # config.cudaForwardCompat :: Bool
  # Whether to include the forward compatibility gencode (+PTX)
  # to support future GPU generations.
  # E.g. true
  #
  # Please see the accompanying documentation or https://github.com/NixOS/nixpkgs/pull/205351

  # gpus :: List Gpu
  gpus = builtins.import ./gpus.nix;

  # isSupported :: Gpu -> Bool
  isSupported = gpu:
    let
      inherit (gpu) minCudaVersion maxCudaVersion;
      lowerBoundSatisfied = strings.versionAtLeast cudaVersion minCudaVersion;
      upperBoundSatisfied = (maxCudaVersion == null)
        || !(strings.versionOlder maxCudaVersion cudaVersion);
    in
    lowerBoundSatisfied && upperBoundSatisfied;

  # isDefault :: Gpu -> Bool
  isDefault = gpu:
    let
      inherit (gpu) dontDefaultAfter;
      newGpu = dontDefaultAfter == null;
      recentGpu = newGpu || strings.versionAtLeast dontDefaultAfter cudaVersion;
    in
    recentGpu;

  # supportedGpus :: List Gpu
  # GPUs which are supported by the provided CUDA version.
  supportedGpus = builtins.filter isSupported gpus;

  # defaultGpus :: List Gpu
  # GPUs which are supported by the provided CUDA version and we want to build for by default.
  defaultGpus = builtins.filter isDefault supportedGpus;

  # supportedCapabilities :: List Capability
  supportedCapabilities = lists.map (gpu: gpu.computeCapability) supportedGpus;

  # defaultCapabilities :: List Capability
  # The default capabilities to target, if not overridden by the user.
  defaultCapabilities = lists.map (gpu: gpu.computeCapability) defaultGpus;

  # cudaArchNameToVersions :: AttrSet String (List String)
  # Maps the name of a GPU architecture to different versions of that architecture.
  # For example, "Ampere" maps to [ "8.0" "8.6" "8.7" ].
  cudaArchNameToVersions =
    lists.groupBy'
      (versions: gpu: versions ++ [ gpu.computeCapability ])
      [ ]
      (gpu: gpu.archName)
      supportedGpus;

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

  formatCapabilities = { cudaCapabilities, enableForwardCompat ? true }: rec {
    inherit cudaCapabilities enableForwardCompat;

    # archNames :: List String
    # E.g. [ "Turing" "Ampere" ]
    archNames = lists.unique (builtins.map (cap: cudaComputeCapabilityToName.${cap}) cudaCapabilities);

    # realArches :: List String
    # The real architectures are physical architectures supported by the CUDA version.
    # E.g. [ "sm_75" "sm_86" ]
    realArches = archMapper "sm" cudaCapabilities;

    # virtualArches :: List String
    # The virtual architectures are typically used for forward compatibility, when trying to support
    # an architecture newer than the CUDA version allows.
    # E.g. [ "compute_75" "compute_86" ]
    virtualArches = archMapper "compute" cudaCapabilities;

    # arches :: List String
    # By default, build for all supported architectures and forward compatibility via a virtual
    # architecture for the newest supported architecture.
    # E.g. [ "sm_75" "sm_86" "compute_86" ]
    arches = realArches ++
      lists.optional enableForwardCompat (lists.last virtualArches);

    # gencode :: List String
    # A list of CUDA gencode arguments to pass to NVCC.
    # E.g. [ "-gencode=arch=compute_75,code=sm_75" ... "-gencode=arch=compute_86,code=compute_86" ]
    gencode =
      let
        base = gencodeMapper "sm" cudaCapabilities;
        forward = gencodeMapper "compute" [ (lists.last cudaCapabilities) ];
      in
      base ++ lib.optionals enableForwardCompat forward;
  };

in
# When changing names or formats: pause, validate, and update the assert
assert (formatCapabilities { cudaCapabilities = [ "7.5" "8.6" ]; }) == {
  cudaCapabilities = [ "7.5" "8.6" ];
  enableForwardCompat = true;

  archNames = [ "Turing" "Ampere" ];
  realArches = [ "sm_75" "sm_86" ];
  virtualArches = [ "compute_75" "compute_86" ];
  arches = [ "sm_75" "sm_86" "compute_86" ];

  gencode = [ "-gencode=arch=compute_75,code=sm_75" "-gencode=arch=compute_86,code=sm_86" "-gencode=arch=compute_86,code=compute_86" ];
};
{
  # formatCapabilities :: { cudaCapabilities: List Capability, cudaForwardCompat: Boolean } ->  { ... }
  inherit formatCapabilities;

  # cudaArchNameToVersions :: String => String
  inherit cudaArchNameToVersions;

  # cudaComputeCapabilityToName :: String => String
  inherit cudaComputeCapabilityToName;

  # dropDot :: String -> String
  inherit dropDot;
} // formatCapabilities {
  cudaCapabilities = config.cudaCapabilities or defaultCapabilities;
  enableForwardCompat = config.cudaForwardCompat or true;
}
