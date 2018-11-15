{ pkgs, newScope, writeScript, stdenv}:

with builtins;
let
  callPackage = newScope self;

  self = rec {
    julia-manifest = "${getEnv "HOME"}" + "/.config/julia-nix/Manifest.toml";
    /* julia-binary = callPackage ./julia.nix { }; */
    julia-chroot = callPackage ./chrootenv.nix { };
    julia-run = julia-chroot.run;
    julia-freeze = writeScript "julia-freeze" ''
    #!${stdenv.shell}
    cp ${getEnv "HOME"}/.julia/environments/v1.0/Manifest.toml ${julia-manifest}
    '';
    julia-rebuild = julia-chroot.rebuild;
  };

in self

/*
TODO
test rebuild / freeze with current nux Julia
create julia-mkl package
 */
