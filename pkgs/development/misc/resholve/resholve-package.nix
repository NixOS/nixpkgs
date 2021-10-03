{ stdenv, lib, resholve, resholve-utils }:

{ pname
, src
, version
, passthru ? { }
, solutions
, ...
}@attrs:
let
  inherit stdenv;

  self = (stdenv.mkDerivation ((removeAttrs attrs [ "solutions" ])
    // {
    inherit pname version src;
    buildInputs = (lib.optionals (builtins.hasAttr "buildInputs" attrs) attrs.buildInputs) ++ [ resholve ];

    # enable below for verbose debug info if needed
    # supports default python.logging levels
    # LOGLEVEL="INFO";
    /*
      subshell/PS4/set -x and : command to output resholve envs
      and invocation. Extra context makes it clearer what the
      Nix API is doing, makes nix-shell debugging easier, etc.
    */
    preFixup = ''
      (
        cd "$out"
        PS4=$'\x1f'"\033[33m[resholve context]\033[0m "
        set -x
        : changing directory to $PWD
        ${builtins.concatStringsSep "\n" (resholve-utils.makeCommands solutions)}
      )
    '';
  }));
in
lib.extendDerivation true passthru self
