{
  callPackage,
  callPackages,
  cudaNamePrefix,
  lib,
  pkgs,
  runCommand,
}:
let
  consumer =
    {
      cuda_nvcc,
      cuda_cudart,
      stdenv,
      label ? "default",
    }:
    stdenv.mkDerivation {
      name = "cuda-scope-consumer-${label}";
      nativeBuildInputs = [ cuda_nvcc ];
      buildInputs = [ cuda_cudart ];
      buildCommand = "touch $out";
    };
  individual = callPackage consumer { };
  grouped = callPackages (lib.mirrorFunctionArgs consumer (args: {
    first = consumer args;
    second = consumer (args // { label = "second"; });
  })) { };

  # Explicit arguments may be consumed through an argument alias or a plain
  # function parameter, so they cannot be filtered by functionArgs again.
  preservesExplicitArgs =
    f:
    let
      member = (callPackages f { extra = "explicit"; }).member;
    in
    member.value == "explicit"
    &&
      (member.override (old: {
        extra = old.extra + "-updated";
      })).value == "explicit-updated";

  # A cross-only alias override runs after the alias overlay used by .pkgs.
  # Reject the resulting mixed-version scope instead of silently accepting it.
  conflicting = import pkgs.path {
    localSystem = "x86_64-linux";
    crossSystem = "aarch64-linux";
    config = {
      allowUnfree = true;
      cudaCapabilities = [ "8.0" ];
    };
    crossOverlays = [ (final: _: { cudaPackages = final.cudaPackages_13; }) ];
  };
  conflict = builtins.tryEval conflicting.cudaPackages_12_9.pkgs.cudaPackages.cudaMajorMinorVersion;

  # CUDA 12.9 has manifest keys absent from 12.8. Comparing recursively
  # spliced manifests can hide this mismatch in HOST while inventing one in
  # BUILD. Selecting HOST's named release must rebind the complete graph.
  mixed = import pkgs.path {
    localSystem = "x86_64-linux";
    crossSystem = "aarch64-linux";
    config = {
      allowUnfree = true;
      cudaCapabilities = [ "8.0" ];
    };
    overlays = [
      (final: _: {
        cudaPackages = final.cudaPackages_12_8;
        cudaPackages_12 = final.cudaPackages_12_8;
      })
    ];
    crossOverlays = [
      (final: _: {
        cudaPackages = final.cudaPackages_12_9;
        cudaPackages_12 = final.cudaPackages_12_9;
        # Alias agreement alone must not accept a different release hidden
        # behind the requested name in another dependency role.
        cudaPackages_13_3 = final.cudaPackages_12_9;
      })
    ];
  };
  mixedConsumer = mixed.cudaPackages_12_9.callPackage consumer { };
  renamedConflict = builtins.tryEval mixed.pkgsBuildHost.cudaPackages_13_3.pkgs.cudaPackages.cudaMajorMinorVersion;

  # Default-release use and inspection of internal cache attributes must not
  # instantiate a variant. Package traversal may inspect these attributes.
  unextended = import pkgs.path {
    localSystem = "x86_64-linux";
    config = {
      allowUnfree = true;
      cudaCapabilities = [ "8.0" ];
    };
    overlays = [
      (_: prev: {
        __stage = prev.__stage // {
          extendGraph = _: throw "CUDA scope instantiated an unused variant";
        };
      })
    ];
  };

  # Equal platforms can still name distinct stages, and crossOverlays must
  # remain exclusive to HOST when constructing a non-default CUDA variant.
  preservesStage =
    crossSystem:
    let
      original = import pkgs.path {
        localSystem = "x86_64-linux";
        inherit crossSystem;
        config = {
          allowUnfree = true;
          cudaCapabilities = [ "8.0" ];
        };
        overlays = [
          (final: prev: {
            scopeTrace = [ ];
            # External packages close over their own package fixed point.
            # Splicing a CUDA scope alone cannot rebind this two-hop dependency.
            scopeCudaLeaf = final.cudaPackages.cudaMajorMinorVersion;
            scopeCudaParent = {
              version = final.scopeCudaLeaf;
            };
            _cuda = prev._cuda.extend (
              _: prevCuda: {
                extensions = prevCuda.extensions ++ [
                  (finalCuda: _: {
                    # Lexical captures stay in the outer overlay's fixed point.
                    # Resolve external dependencies through the CUDA scope to
                    # obtain automatic transitive release selection.
                    scopeCaptured = final.scopeCudaParent;
                    scopeScoped = finalCuda.callPackage ({ scopeCudaParent }: scopeCudaParent) { };
                    scopeExplicit = finalCuda.pkgs.scopeCudaParent;
                  })
                ];
              }
            );
            scopeDependency = final.runCommand "cuda-scope-dependency" { } ''
              echo '${builtins.toJSON final.scopeTrace}' > "$out"
            '';
          })
        ];
        crossOverlays = [ (_: prev: { scopeTrace = prev.scopeTrace ++ [ "HOST" ]; }) ];
        # A custom stage may have its own overlays in addition to the import's
        # regular overlays. Extending through that stage must not promote them
        # into regular overlays or apply them twice when reconstructing it.
        stdenvStages =
          args:
          let
            stages = import (pkgs.path + /pkgs/stdenv) args;
          in
          lib.imap0 (
            index: f: previous:
            let
              stage = f previous;
            in
            stage
            // lib.optionalAttrs (index == builtins.length stages - 3) {
              overlays = stage.overlays ++ [
                (_: prev: { scopeTrace = prev.scopeTrace ++ [ "NATIVE" ]; })
              ];
            }
          ) stages;
      };
      stageConsumer =
        { scopeDependency, stdenv }:
        stdenv.mkDerivation {
          name = "cuda-scope-stage-consumer";
          buildInputs = [ scopeDependency ];
          buildCommand = "touch $out";
        };
      explicitRoleConsumer =
        { pkgs, stdenv }:
        stdenv.mkDerivation {
          name = "cuda-scope-explicit-role-consumer";
          # pkgsBuildHost already selects this dependency's role. Splicing
          # scope.pkgs again would shift it a second time into BUILD/BUILD.
          nativeBuildInputs = [ pkgs.pkgsBuildHost.scopeDependency ];
          buildCommand = "touch $out";
        };
      publicCuda = original.cudaPackages_13_3;
      expectedExplicit = original.callPackage explicitRoleConsumer {
        pkgs = original.pkgsHostTarget.cudaPackages_13_3.pkgs;
      };
      publicConsumers = [
        (original.callPackage explicitRoleConsumer { pkgs = publicCuda.pkgs; })
        (publicCuda.callPackage explicitRoleConsumer { })
        (publicCuda.pkgs.callPackage explicitRoleConsumer { })
      ];
    in
    lib.assertMsg (lib.all (actual: actual.drvPath == expectedExplicit.drvPath)
      publicConsumers
    ) "CUDA scope: all public package graph routes must preserve explicit dependency roles"
    &&
      lib.all
        (
          role:
          let
            source = original.${role};
            cuda = source.cudaPackages_13_3;
            variant = cuda.pkgs;
            localPkgs = cuda.overrideScope (
              _: _: {
                pkgs = {
                  localMarker = true;
                };
              }
            );
          in
          variant.scopeTrace == source.scopeTrace
          && variant.pkgsBuildHost.scopeTrace == source.pkgsBuildHost.scopeTrace
          && variant.cudaPackages.cudaMajorMinorVersion == "13.3"
          && source.scopeCudaParent.version == "12.9"
          && (cuda.callPackage ({ scopeCudaParent }: scopeCudaParent) { }).version == "13.3"
          && cuda.scopeCaptured.version == "12.9"
          && cuda.scopeScoped.version == "13.3"
          && cuda.scopeExplicit.version == "13.3"
          && variant.cudaPackages.scopeCaptured.version == "13.3"
          && (cuda.callPackage stageConsumer { }).drvPath == (source.callPackage stageConsumer { }).drvPath
          && lib.assertMsg (
            (cuda.callPackage explicitRoleConsumer { }).drvPath
            == (variant.callPackage explicitRoleConsumer { pkgs = variant; }).drvPath
          ) "CUDA scope: an explicitly selected BUILD/HOST dependency must not be spliced again"
          && localPkgs.callPackage ({ pkgs }: pkgs.localMarker && !(pkgs ? stdenv)) { }
        )
        [
          "pkgsHostTarget"
          "pkgsBuildHost"
          "pkgsBuildBuild"
        ];

  # Comparing the resulting derivations checks selection of both the BUILD
  # compiler and HOST runtime. Merely checking versions would miss a grouped
  # package receiving an unspliced HOST compiler as a native build input.
  same =
    label: actual: expected:
    lib.assertMsg (actual.drvPath == expected.drvPath) "CUDA scope: ${label}";
in
assert same "callPackages must use callPackage's spliced arguments" grouped.first individual;
assert same "each group member must retain its own arguments" grouped.second (
  individual.override { label = "second"; }
);
assert same "group member overrides must re-evaluate the member" (grouped.first.override {
  label = "override";
}) (individual.override { label = "override"; });
assert same "callPackages explicit arguments must override defaults" ((callPackages
  (lib.mirrorFunctionArgs consumer (args: {
    first = consumer args;
  }))
  {
    label = "explicit";
  }
).first
) (individual.override { label = "explicit"; });
assert lib.assertMsg (preservesExplicitArgs (args: {
  member.value = args.extra or "missing";
})) "CUDA scope: generic grouped functions and their overrides must retain explicit arguments";
assert lib.assertMsg (preservesExplicitArgs (
  args@{ cudaNamePrefix, ... }:
  {
    member.value = args.extra or "missing";
  }
)) "CUDA scope: ellipsis grouped functions and their overrides must retain explicit arguments";
assert lib.assertMsg (!conflict.success) "CUDA scope: .pkgs must reject conflicting crossOverlays";
assert lib.assertMsg (
  !renamedConflict.success
) "CUDA scope: matching aliases must not hide a different named release in TARGET";
assert mixed.pkgsBuildHost.cudaPackages.cudaMajorMinorVersion == "12.8";
assert mixed.cudaPackages_12_9.pkgs.pkgsBuildHost.cudaPackages.cudaMajorMinorVersion == "12.9";
assert lib.versions.majorMinor (builtins.head mixedConsumer.nativeBuildInputs).version == "12.9";
assert lib.versions.majorMinor (builtins.head mixedConsumer.buildInputs).version == "12.9";
assert builtins.isString unextended.cudaPackages_12_9.cuda_nvcc.drvPath;
assert !unextended.cudaPackages_12_9._pkgsVariant.recurseForDerivations;
assert !unextended.cudaPackages_13_3._pkgsVariant.recurseForDerivations;
assert lib.assertMsg (preservesStage "aarch64-linux")
  "CUDA scope: cross-only overlays must remain exclusive to HOST and run once";
assert lib.assertMsg (preservesStage "x86_64-linux")
  "CUDA scope: equal-platform stages must retain distinct dependency scopes";
# These are evaluation assertions: no CUDA compiler or runtime needs building.
runCommand "${cudaNamePrefix}-tests-scope" { } ''
  touch "$out"
''
