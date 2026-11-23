{
  lib,
  python,
  buildEnv,
  pythonPackages,
}:

let
  inherit (python.stdenv) buildPlatform hostPlatform targetPlatform;

  # Keep platform variants in sync, including after chained overrides.
  spliceEnvs =
    envs:
    let
      hostEnv = envs.hostTarget;

      updateEnvs = updateEnv: spliceEnvs (lib.mapAttrs (_: variant: updateEnv variant) envs);

      overrideMethods = {
        override = lib.mirrorFunctionArgs hostEnv.override (
          overrides: updateEnvs (variant: variant.override overrides)
        );

        overrideDerivation = overrides: updateEnvs (variant: variant.overrideDerivation overrides);
      }
      # overrideDerivation returns a raw derivation without overrideAttrs.
      // lib.optionalAttrs (hostEnv ? overrideAttrs) {
        overrideAttrs = overrides: updateEnvs (variant: variant.overrideAttrs overrides);
      };
    in
    # Attach the methods and splices to every output, including .out.
    lib.extendDerivation true (overrideMethods // { __spliced = envs; }) hostEnv;
in

f:
let
  env = buildEnv.override { extraLibs = f pythonPackages; };
in
# Keep native scope overrides by using this package set directly.
if buildPlatform == hostPlatform && hostPlatform == targetPlatform then
  env
else
  spliceEnvs (
    lib.mapAttrs (_: variant: variant.withPackages f) {
      buildBuild = python.pythonOnBuildForBuild;
      buildHost = python.pythonOnBuildForHost;
      buildTarget = python.pythonOnBuildForTarget;
      hostHost = python.pythonOnHostForHost;
    }
    // {
      hostTarget = env;
    }
  )
