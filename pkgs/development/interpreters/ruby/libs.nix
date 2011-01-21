{stdenv, config, fetchurl, callPackage}:

let
  generated = stdenv.lib.attrByPath [ "gems" "generated" ] (import ./generated.nix) config;
  auto = generated merged;
  patches = callPackage ./patches.nix { } gems;
  overwrites = callPackage ./overwrites.nix { } gems;
  merged = stdenv.lib.mapAttrs gem auto.gems;
  gem = callPackage ./gem.nix { inherit patches overwrites; };
  gems = merged // auto.aliases;
in
gems
