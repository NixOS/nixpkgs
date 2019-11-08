{ haskell, haskellPackages, stdenvNoCC }:

let
  static = haskell.lib.justStaticExecutables haskellPackages.dhall_1_27_0;

in static.overrideAttrs (old: {
  passthru = old.passthru or {} // {
    prelude = stdenvNoCC.mkDerivation {
      name = "dhall-prelude";
      inherit (old) src;
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        mkdir $out
        cp -r Prelude/* $out/
      '';
    };
  };
})
