{ stdenv, lib }:

let
  variant = if stdenv.hostPlatform.isMusl then "alpine_linux" else "linux";
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk17.${variant}.jdk.hotspot; };
  jre-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk17.${variant}.jre.hotspot; };
  jdk-openj9 = throw "openjdk17 on linux is missing jdk-openj9";
  jre-openj9 = throw "openjdk17 on linux is missing jre-openj9";
}
