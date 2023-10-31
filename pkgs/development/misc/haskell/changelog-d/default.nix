{ callPackage
, lib
, pkgs
}:

(callPackage ./changelog-d.nix { }).overrideAttrs (oldAttrs: {

  version = oldAttrs.version + "-git-${lib.strings.substring 0 7 oldAttrs.src.rev}";

  passthru.updateScript = lib.getExe (pkgs.writeShellApplication {
    name = "update-changelog-d";
    runtimeInputs = [
      pkgs.cabal2nix
    ];
    text = ''
      cd pkgs/development/misc/haskell/changelog-d
      cabal2nix https://codeberg.org/fgaz/changelog-d >changelog-d.nix
    '';
  });

  meta = oldAttrs.meta // {
    homepage = "https://codeberg.org/fgaz/changelog-d";
    maintainers = [ lib.maintainers.roberth ];
  };

})
