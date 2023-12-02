{ buildEnv, pythonPackages }:

f: let
  packages = f pythonPackages;
in
buildEnv.override {
  # Compute required dependencies recursively.
  extraLibs = packages ++ pythonPackages.requiredPythonModules packages;
}
