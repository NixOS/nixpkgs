{
  _cuda,
  config,
  lib,
  pkgs,
  # Manually provided arguments
  manifests,
}:
let
  inherit (lib.customisation) callPackagesWith;
  inherit (lib.filesystem) packagesFromDirectoryRecursive;
  inherit (lib.fixedPoints) composeManyExtensions extends;
  inherit (lib.lists) optionals;
  inherit (lib.strings) versionAtLeast versionOlder;
  inherit (lib.versions) major majorMinor;
  inherit (_cuda.lib)
    dropDots
    formatCapabilities
    mkVersionedName
    ;

  # NOTE: This value is considered an implementation detail and should not be exposed in the attribute set.
  cudaMajorMinorPatchVersion = manifests.cuda.release_label;
  cudaMajorMinorVersion = majorMinor cudaMajorMinorPatchVersion;
  cudaMajorVersion = major cudaMajorMinorPatchVersion;

  majorName = mkVersionedName "cudaPackages" cudaMajorVersion;
  minorName = mkVersionedName "cudaPackages" cudaMajorMinorVersion;

  # Make this CUDA release the default for transitive dependencies too.
  # See `Using cudaPackages.pkgs` in the manual for the coherence contract.
  pkgs' =
    let
      isDefault =
        packages:
        # A stage overlay can rename the named scope as well as its aliases.
        packages.${minorName}.cudaMajorMinorVersion == cudaMajorMinorVersion
        && packages.${minorName}.manifests == packages.${majorName}.manifests
        && packages.${minorName}.manifests == packages.cudaPackages.manifests;
      # Manifests are data, but ordinary attribute sets are recursively spliced.
      # Compare each unspliced role explicitly: comparing merged manifests can
      # mistake foreign component keys for differences in the selected release.
      hasDefaultRelease =
        packages:
        # The synthetic final TARGET stage only supplies stdenv.cc.
        lib.all (role: !(role ? cudaPackages) || isDefault role) (
          lib.attrValues (lib.customisation.renameCrossIndexFrom "pkgs" packages)
        );
    in
    if hasDefaultRelease pkgs then
      # Preserve the original stage when no extension is necessary.
      pkgs
    else
      let
        stage = pkgs.__stage.select pkgs.pkgsBuildBuild.${minorName}._pkgsVariant.pkgs;
      in
      assert lib.assertMsg (hasDefaultRelease stage) ''
        ${minorName}.pkgs: the CUDA aliases do not select ${minorName} consistently after extending Nixpkgs.
        A stage-specific overlay changed ${minorName}, ${majorName}, or cudaPackages. Select the CUDA package
        set in regular overlays so every dependency role uses the same release.
      '';
      stage;

  # Share one version-rebound graph across requesting dependency roles and
  # local scope overrides; the cache does not depend on their fixed points.
  # Extend the original import so stage-specific overlays retain their placement.
  _pkgsVariant = {
    # Inspecting this internal cache must not instantiate its graph.
    recurseForDerivations = false;
    pkgs = pkgs.__stage.extendGraph (
      final: _: {
        recurseForDerivations = false;
        ${majorName} = final.${minorName};
        cudaPackages = final.${majorName};
      }
    );
  };

  cudaPackagesFixedPoint =
    finalCudaPackages:
    let
      # Keep the returned compiler and stdenv constructor APIs: callPackage
      # overrides only this outer result, not their own override attributes.
      backend = finalCudaPackages.callPackage ./backend.nix { };
    in
    {
      # Keep _cuda outside this fixed point: manifest selection uses its pure
      # configuration and data before the spliced package sets can be built.

      inherit
        cudaMajorMinorPatchVersion
        cudaMajorMinorVersion
        cudaMajorVersion
        ;

      pkgs = pkgs';

      backendCC = backend.cc;
      backendStdenv = backend.stdenv;

      inherit _pkgsVariant;

      # Core
      # Resolve through callPackage so grouped packages receive the same
      # spliced arguments and scope overrides as individual packages.
      callPackages =
        fn: args:
        let
          f = if lib.isFunction fn then fn else import fn;
          resolved = finalCudaPackages.callPackage (lib.mirrorFunctionArgs f (args: {
            inherit args;
          })) args;
        in
        callPackagesWith resolved.args f args;

      cudaNamePrefix = "cuda${cudaMajorMinorVersion}";

      cudaOlder = versionOlder cudaMajorMinorVersion;
      cudaAtLeast = versionAtLeast cudaMajorMinorVersion;

      # These must be modified through callPackage, not by overriding the scope, since we cannot
      # depend on them recursively as they are used to add top-level attributes.
      inherit manifests;

      # Manifest selection needs configuration before the package fixed point
      # (and its version-specific Nixpkgs instance) can be evaluated.
      cudaConfig = import ./cudaConfig.nix {
        inherit
          _cuda
          config
          cudaMajorMinorVersion
          lib
          ;
      };

      # A redist is an executable/library for the package's host. Splicing
      # selects that package; no build/host/target redist fields are needed.
      redistSystem = _cuda.lib.getRedistSystem {
        inherit (finalCudaPackages.cudaConfig) cudaCapabilities;
        inherit cudaMajorMinorVersion;
        inherit (pkgs.stdenv.hostPlatform) system;
      };

      # Keep the extendMkDerivation helper undecorated and select its construction
      # dependencies explicitly, before ordinary package argument splicing.
      buildRedist = import ./buildRedist {
        inherit
          _cuda
          lib
          ;
        inherit (pkgs)
          autoAddDriverRunpath
          autoPatchelfHook
          fetchurl
          srcOnly
          stdenvNoCC
          zstd
          ;
        # GCC's library output is for its TARGET. Select BUILD -> HOST before
        # taking that output, including when this redist itself is a BUILD tool.
        inherit (pkgs.pkgsBuildHost) gccForLibs;
        inherit (finalCudaPackages)
          autoAddCudaCompatRunpath
          redistSystem
          cudaComponentHook
          cudaMajorMinorVersion
          cudaMajorVersion
          cudaNamePrefix
          manifests
          ;
        # This hook is propagated to consumers as a native build dependency.
        removeStubsFromRunpathHook = pkgs'.pkgsBuildHost.cudaPackages.removeStubsFromRunpathHook;
      };

      flags =
        formatCapabilities {
          inherit (finalCudaPackages.cudaConfig) cudaCapabilities cudaForwardCompat;
          inherit (_cuda.db) cudaCapabilityToInfo;
        }
        # TODO(@connorbaker): Enable the corresponding warnings in `./aliases.nix` after some
        # time to allow users to migrate to cudaLib and cudaConfig.
        // {
          inherit dropDots;
          cudaComputeCapabilityToName =
            cudaCapability: _cuda.db.cudaCapabilityToInfo.${cudaCapability}.archName;
          dropDot = dropDots;
          isJetsonBuild = finalCudaPackages.cudaConfig.hasJetsonCudaCapability;
        };
    }
    // packagesFromDirectoryRecursive {
      inherit (finalCudaPackages) callPackage;
      directory = ./packages;
    };

  composedExtensions = composeManyExtensions (
    optionals config.allowAliases [
      (import ./aliases.nix { inherit lib; })
    ]
    ++ _cuda.extensions
  );

  # Construct the scope before forcing its release-specific Nixpkgs graph.
  # The helper from pkgs' would force that graph while looking up the helper.
  cudaPackages =
    lib.makeScopeWithSplicing'
      {
        splicePackages = pkgs'.splicePackages;
        newScope = pkgs'.newScope;
      }
      {
        # The rebound graph supplies this release's other dependency-role scopes.
        # Local overrideScope changes apply only to self, as in the standard helper.
        otherSplices = pkgs'.generateSplicesForMkScope [ "cudaPackages" ];
        # A local overrideScope may replace pkgs with a plain attribute set.
        # Preserve that replacement instead of merging other roles into it.
        keep = self: { inherit (self) pkgs; };
        f = extends composedExtensions cudaPackagesFixedPoint;
      };
in
cudaPackages
