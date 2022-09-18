{ callPackage, ... }:

let
  idris2-no-deps = callPackage ./idris2-compiler.nix { };

  builtin = { inherit (idris2-no-deps) base contrib network prelude test; };

  with-packages-no-deps = callPackage ./with-packages.nix {
    idris2 = idris2-no-deps;
  };
in {
  inherit idris2-no-deps builtin with-packages-no-deps;

  with-packages = packages:
    with-packages-no-deps (packages ++ (with builtin; [ prelude base ]));

  builtins = builtins.attrValues builtin;
}
