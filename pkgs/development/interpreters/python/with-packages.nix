{ buildEnv, pythonPackages }:

f: let
  buildEnv' = extraLibs: let
    env = buildEnv.override { inherit extraLibs; };
    addPackages = g: buildEnv' (extraLibs ++ (g pythonPackages));
    in env.overrideAttrs (self:
      { passthru = self.passthru // { inherit addPackages; };});
in buildEnv' (f pythonPackages)
