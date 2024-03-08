{ stdenv, lib }:

let
  variant = if stdenv.hostPlatform.isMusl then "alpine_linux" else "linux";
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk17.${variant}.jdk.hotspot; };
  jre-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk17.${variant}.jre.hotspot; };
}
