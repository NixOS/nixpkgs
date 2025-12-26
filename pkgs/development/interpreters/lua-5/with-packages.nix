{ buildEnv, luaPackages }:

# this is a function that returns a function that returns an environment
f:
let
  packages = f luaPackages;
in
buildEnv.override { extraLibs = packages; }
