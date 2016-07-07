{ pkgs
, stdenv
, interpreter
#, interpreterConfig ? (self: super: {})
, overrides ? (self: super: {})
}:


let

  packages = let

    inherit (stdenv.lib) fix' extends fold;

    pythonPackages = self:
      let
        python = interpreter;
      in import ./support.nix { inherit pkgs python; } self;

    commonConfiguration = import ./common-configuration.nix { inherit pkgs stdenv; };

  #in fix' (fold extends [ overrides commonConfiguration pythonPackages ])
  in fix' (extends overrides (extends commonConfiguration pythonPackages));

  buildEnv = pkgs.callPackage ../interpreters/python/wrapper.nix {
    inherit (pkgs) buildEnv makeWrapper;
    python = interpreter;
  };

  withPackages = import ../interpreters/python/with-packages.nix {
    inherit buildEnv;
    pythonPackages = packages;
  };

in {
# For each interpreter version we have this set.
  pkgs = packages;
  inherit withPackages;
  inherit buildEnv;
  inherit interpreter;
}
