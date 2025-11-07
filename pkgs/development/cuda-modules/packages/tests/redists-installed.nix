{
  _cuda,
  backendStdenv,
  cudaNamePrefix,
  lib,
  linkFarm,
  tests,
}:
# NOTE: Because Nixpkgs, by default, allows aliases, this derivation may contain multiple entries for a single redistributable.
let
  # redists-unpacked has already found all the names of the redistributables
  availableRedistsForPlatform = lib.filterAttrs (
    _: value:
    let
      canInstantiate =
        (builtins.tryEval (
          builtins.deepSeq ((value.drvPath or null) != null) ((value.drvPath or null) != null)
        )).value;
    in
    lib.warnIfNot canInstantiate
      "Package ${value.name} is unavailable and will not be included in redists-installed"
      canInstantiate
  ) tests.redists-unpacked.passthru.redistsForPlatform;

  mkOutputs =
    name: drv:
    lib.genAttrs' drv.outputs (output: {
      name = "${name}-${output}";
      value = drv.${output};
    });

  linkedWithoutLicenses = linkFarm "${cudaNamePrefix}-redists-installed" (
    lib.concatMapAttrs mkOutputs availableRedistsForPlatform
  );
in
linkedWithoutLicenses.overrideAttrs (
  finalAttrs: prevAttrs: {
    passthru = prevAttrs.passthru or { } // {
      inherit availableRedistsForPlatform;

      brokenAssertions = prevAttrs.passthru.brokenAssertions or [ ] ++ [
        {
          message =
            "No redists are available for the current NVIDIA system identifier (${backendStdenv.hostRedistSystem});"
            + " ensure proper licenses are allowed and that the CUDA version in use supports the system";
          assertion = availableRedistsForPlatform != { };
        }
      ];
    };

    meta = prevAttrs.meta or { } // {
      broken = _cuda.lib._mkMetaBroken finalAttrs;
      license = lib.unique (
        lib.concatMap (drv: lib.toList (drv.meta.license or [ ])) (
          lib.attrValues availableRedistsForPlatform
        )
      );
    };
  }
)
