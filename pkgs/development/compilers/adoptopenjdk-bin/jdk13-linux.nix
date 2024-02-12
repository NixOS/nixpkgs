{ stdenv, lib }:

let
  variant = if stdenv.hostPlatform.isMusl then "alpine_linux" else "linux";
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk13.${variant}.jdk.hotspot; knownVulnerabilities = ["Support ended"]; };
  jre-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk13.${variant}.jre.hotspot; knownVulnerabilities = ["Support ended"]; };
  jdk-openj9 = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk13.${variant}.jdk.openj9; knownVulnerabilities = ["Support ended"]; };
  jre-openj9 = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk13.${variant}.jre.openj9; knownVulnerabilities = ["Support ended"]; };
}
