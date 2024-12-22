# Type aliases
# Gpu :: AttrSet
#   - See the documentation in ./gpus.nix.
{
  config,
  cudaCapabilities ? (config.cudaCapabilities or [ ]),
  cudaForwardCompat ? (config.cudaForwardCompat or true),
  lib,
  cudaVersion,
  stdenv,
  # gpus :: List Gpu
  gpus,
}:
let
  inherit (lib)
    asserts
    attrsets
    lists
    strings
    trivial
    ;

  inherit (stdenv) hostPlatform;

  # Flags are determined based on your CUDA toolkit by default.  You may benefit
  # from improved performance, reduced file size, or greater hardware support by
  # passing a configuration based on your specific GPU environment.
  #
  # cudaCapabilities :: List Capability
  # List of hardware generations to build.
  # E.g. [ "8.0" ]
  # Currently, the last item is considered the optional forward-compatibility arch,
  # but this may change in the future.
  #
  # cudaForwardCompat :: Bool
  # Whether to include the forward compatibility gencode (+PTX)
  # to support future GPU generations.
  # E.g. true
  #
  # Please see the accompanying documentation or https://github.com/NixOS/nixpkgs/pull/205351

  # isSupported :: Gpu -> Bool
  isSupported =
    gpu:
    let
      inherit (gpu) minCudaVersion maxCudaVersion;
      lowerBoundSatisfied = strings.versionAtLeast cudaVersion minCudaVersion;
      upperBoundSatisfied =
        (maxCudaVersion == null) || !(strings.versionOlder maxCudaVersion cudaVersion);
    in
    lowerBoundSatisfied && upperBoundSatisfied;

  # NOTE: Jetson is never built by default.
  # isDefault :: Gpu -> Bool
  isDefault =
    gpu:
    let
      inherit (gpu) dontDefaultAfter isJetson;
      newGpu = dontDefaultAfter == null;
      recentGpu = newGpu || strings.versionAtLeast dontDefaultAfter cudaVersion;
    in
    recentGpu && !isJetson;

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
  cudaArchNameToVersions = lists.groupBy' (versions: gpu: versions ++ [ gpu.computeCapability ]) [ ] (
    gpu: gpu.archName
  ) supportedGpus;

  # cudaComputeCapabilityToName :: AttrSet String String
  # Maps the version of a GPU architecture to the name of that architecture.
  # For example, "8.0" maps to "Ampere".
  cudaComputeCapabilityToName = builtins.listToAttrs (
    lists.map (gpu: attrsets.nameValuePair gpu.computeCapability gpu.archName) supportedGpus
  );

  # cudaComputeCapabilityToIsJetson :: AttrSet String Boolean
  cudaComputeCapabilityToIsJetson = builtins.listToAttrs (
    lists.map (attrs: attrsets.nameValuePair attrs.computeCapability attrs.isJetson) supportedGpus
  );

  # jetsonComputeCapabilities :: List String
  jetsonComputeCapabilities = trivial.pipe cudaComputeCapabilityToIsJetson [
    (attrsets.filterAttrs (_: isJetson: isJetson))
    builtins.attrNames
  ];

  # Find the intersection with the user-specified list of cudaCapabilities.
  # NOTE: Jetson devices are never built by default because they cannot be targeted along with
  # non-Jetson devices and require an aarch64 host platform. As such, if they're present anywhere,
  # they must be in the user-specified cudaCapabilities.
  # NOTE: We don't need to worry about mixes of Jetson and non-Jetson devices here -- there's
  # sanity-checking for all that in below.
  jetsonTargets = lists.intersectLists jetsonComputeCapabilities cudaCapabilities;

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
  gencodeMapper =
    feat:
    lists.map (
      computeCapability:
      "-gencode=arch=compute_${dropDot computeCapability},code=${feat}_${dropDot computeCapability}"
    );

  # Maps Nix system to NVIDIA redist arch.
  # NOTE: We swap out the default `linux-sbsa` redist (for server-grade ARM chips) with the
  # `linux-aarch64` redist (which is for Jetson devices) if we're building any Jetson devices.
  # Since both are based on aarch64, we can only have one or the other, otherwise there's an
  # ambiguity as to which should be used.
  # NOTE: This function *will* be called by unsupported systems because `cudaPackages` is part of
  # `all-packages.nix`, which is evaluated on all systems. As such, we need to handle unsupported
  # systems gracefully.
  # getRedistArch :: String -> String
  getRedistArch =
    nixSystem:
    attrsets.attrByPath [ nixSystem ] "unsupported" {
      aarch64-linux = if jetsonTargets != [ ] then "linux-aarch64" else "linux-sbsa";
      x86_64-linux = "linux-x86_64";
      ppc64le-linux = "linux-ppc64le";
      x86_64-windows = "windows-x86_64";
    };

  # Maps NVIDIA redist arch to Nix system.
  # NOTE: This function *will* be called by unsupported systems because `cudaPackages` is part of
  # `all-packages.nix`, which is evaluated on all systems. As such, we need to handle unsupported
  # systems gracefully.
  # getNixSystem :: String -> String
  getNixSystem =
    redistArch:
    attrsets.attrByPath [ redistArch ] "unsupported-${redistArch}" {
      linux-sbsa = "aarch64-linux";
      linux-aarch64 = "aarch64-linux";
      linux-x86_64 = "x86_64-linux";
      linux-ppc64le = "ppc64le-linux";
      windows-x86_64 = "x86_64-windows";
    };

  formatCapabilities =
    {
      cudaCapabilities,
      enableForwardCompat ? true,
    }:
    rec {
      inherit cudaCapabilities enableForwardCompat;

      # archNames :: List String
      # E.g. [ "Turing" "Ampere" ]
      #
      # Unknown architectures are rendered as sm_XX gencode flags.
      archNames = lists.unique (
        lists.map (cap: cudaComputeCapabilityToName.${cap} or "sm_${dropDot cap}") cudaCapabilities
      );

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
      arches = realArches ++ lists.optional enableForwardCompat (lists.last virtualArches);

      # gencode :: List String
      # A list of CUDA gencode arguments to pass to NVCC.
      # E.g. [ "-gencode=arch=compute_75,code=sm_75" ... "-gencode=arch=compute_86,code=compute_86" ]
      gencode =
        let
          base = gencodeMapper "sm" cudaCapabilities;
          forward = gencodeMapper "compute" [ (lists.last cudaCapabilities) ];
        in
        base ++ lib.optionals enableForwardCompat forward;

      # gencodeString :: String
      # A space-separated string of CUDA gencode arguments to pass to NVCC.
      # E.g. "-gencode=arch=compute_75,code=sm_75 ... -gencode=arch=compute_86,code=compute_86"
      gencodeString = strings.concatStringsSep " " gencode;

      # cmakeCudaArchitecturesString :: String
      # A semicolon-separated string of CUDA capabilities without dots, suitable for passing to CMake.
      # E.g. "75;86"
      cmakeCudaArchitecturesString = strings.concatMapStringsSep ";" dropDot cudaCapabilities;

      # Jetson devices cannot be targeted by the same binaries which target non-Jetson devices. While
      # NVIDIA provides both `linux-aarch64` and `linux-sbsa` packages, which both target `aarch64`,
      # they are built with different settings and cannot be mixed.
      # isJetsonBuild :: Boolean
      isJetsonBuild =
        let
          requestedJetsonDevices = lists.filter (
            cap: cudaComputeCapabilityToIsJetson.${cap} or false
          ) cudaCapabilities;
          requestedNonJetsonDevices = lists.filter (
            cap: !(builtins.elem cap requestedJetsonDevices)
          ) cudaCapabilities;
          jetsonBuildSufficientCondition = requestedJetsonDevices != [ ];
          jetsonBuildNecessaryCondition = requestedNonJetsonDevices == [ ] && hostPlatform.isAarch64;
        in
        trivial.throwIf (jetsonBuildSufficientCondition && !jetsonBuildNecessaryCondition) ''
          Jetson devices cannot be targeted with non-Jetson devices. Additionally, they require hostPlatform to be aarch64.
          You requested ${builtins.toJSON cudaCapabilities} for host platform ${hostPlatform.system}.
          Requested Jetson devices: ${builtins.toJSON requestedJetsonDevices}.
          Requested non-Jetson devices: ${builtins.toJSON requestedNonJetsonDevices}.
          Exactly one of the following must be true:
          - All CUDA capabilities belong to Jetson devices and hostPlatform is aarch64.
          - No CUDA capabilities belong to Jetson devices.
          See ${./gpus.nix} for a list of architectures supported by this version of Nixpkgs.
        '' jetsonBuildSufficientCondition
        && jetsonBuildNecessaryCondition;
    };
in
# When changing names or formats: pause, validate, and update the assert
assert
  let
    expected = {
      cudaCapabilities = [
        "7.5"
        "8.6"
      ];
      enableForwardCompat = true;

      archNames = [
        "Turing"
        "Ampere"
      ];
      realArches = [
        "sm_75"
        "sm_86"
      ];
      virtualArches = [
        "compute_75"
        "compute_86"
      ];
      arches = [
        "sm_75"
        "sm_86"
        "compute_86"
      ];

      gencode = [
        "-gencode=arch=compute_75,code=sm_75"
        "-gencode=arch=compute_86,code=sm_86"
        "-gencode=arch=compute_86,code=compute_86"
      ];
      gencodeString = "-gencode=arch=compute_75,code=sm_75 -gencode=arch=compute_86,code=sm_86 -gencode=arch=compute_86,code=compute_86";

      cmakeCudaArchitecturesString = "75;86";

      isJetsonBuild = false;
    };
    actual = formatCapabilities {
      cudaCapabilities = [
        "7.5"
        "8.6"
      ];
    };
    actualWrapped = (builtins.tryEval (builtins.deepSeq actual actual)).value;
  in
  asserts.assertMsg ((strings.versionAtLeast cudaVersion "11.2") -> (expected == actualWrapped)) ''
    This test should only fail when using a version of CUDA older than 11.2, the first to support
    8.6.
    Expected: ${builtins.toJSON expected}
    Actual: ${builtins.toJSON actualWrapped}
  '';
# Check mixed Jetson and non-Jetson devices
assert
  let
    expected = false;
    actual = formatCapabilities {
      cudaCapabilities = [
        "7.2"
        "7.5"
      ];
    };
    actualWrapped = (builtins.tryEval (builtins.deepSeq actual actual)).value;
  in
  asserts.assertMsg (expected == actualWrapped) ''
    Jetson devices capabilities cannot be mixed with non-jetson devices.
    Capability 7.5 is non-Jetson and should not be allowed with Jetson 7.2.
    Expected: ${builtins.toJSON expected}
    Actual: ${builtins.toJSON actualWrapped}
  '';
# Check Jetson-only
assert
  let
    expected = {
      cudaCapabilities = [
        "6.2"
        "7.2"
      ];
      enableForwardCompat = true;

      archNames = [
        "Pascal"
        "Volta"
      ];
      realArches = [
        "sm_62"
        "sm_72"
      ];
      virtualArches = [
        "compute_62"
        "compute_72"
      ];
      arches = [
        "sm_62"
        "sm_72"
        "compute_72"
      ];

      gencode = [
        "-gencode=arch=compute_62,code=sm_62"
        "-gencode=arch=compute_72,code=sm_72"
        "-gencode=arch=compute_72,code=compute_72"
      ];
      gencodeString = "-gencode=arch=compute_62,code=sm_62 -gencode=arch=compute_72,code=sm_72 -gencode=arch=compute_72,code=compute_72";

      cmakeCudaArchitecturesString = "62;72";

      isJetsonBuild = true;
    };
    actual = formatCapabilities {
      cudaCapabilities = [
        "6.2"
        "7.2"
      ];
    };
    actualWrapped = (builtins.tryEval (builtins.deepSeq actual actual)).value;
  in
  asserts.assertMsg
    # We can't do this test unless we're targeting aarch64
    (hostPlatform.isAarch64 -> (expected == actualWrapped))
    ''
      Jetson devices can only be built with other Jetson devices.
      Both 6.2 and 7.2 are Jetson devices.
      Expected: ${builtins.toJSON expected}
      Actual: ${builtins.toJSON actualWrapped}
    '';
{
  # formatCapabilities :: { cudaCapabilities: List Capability, enableForwardCompat: Boolean } ->  { ... }
  inherit formatCapabilities;

  # cudaArchNameToVersions :: String => String
  inherit cudaArchNameToVersions;

  # cudaComputeCapabilityToName :: String => String
  inherit cudaComputeCapabilityToName;

  # dropDot :: String -> String
  inherit dropDot;

  inherit
    defaultCapabilities
    supportedCapabilities
    jetsonComputeCapabilities
    jetsonTargets
    getNixSystem
    getRedistArch
    ;
}
// formatCapabilities {
  cudaCapabilities = if cudaCapabilities == [ ] then defaultCapabilities else cudaCapabilities;
  enableForwardCompat = cudaForwardCompat;
}
