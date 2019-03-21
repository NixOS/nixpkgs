{ pkgs }:

# TODO: add into the toplevel fixpoint instead of using rec
rec {

  prelude = prelude_3_0_0;
  prelude_3_0_0 = pkgs.callPackage ./prelude/v3.nix {};

}
