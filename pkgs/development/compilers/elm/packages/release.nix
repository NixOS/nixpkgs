{ callPackage }:
{
  version = "0.17.0";
  packages = {
    elm-compiler = callPackage ./elm-compiler.nix { };
    elm-package = callPackage ./elm-package.nix { };
    elm-make = callPackage ./elm-make.nix { };
    elm-reactor = callPackage ./elm-reactor.nix { };
    elm-repl = callPackage ./elm-repl.nix { };
  };
}
