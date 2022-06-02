{ lib }:

let
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk14.linux.jdk.hotspot; knownVulnerabilities = ["Support ended"]; };
  jre-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk14.linux.jre.hotspot; knownVulnerabilities = ["Support ended"]; };
  jdk-openj9 = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk14.linux.jdk.openj9; knownVulnerabilities = ["Support ended"]; };
  jre-openj9 = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk14.linux.jre.openj9; knownVulnerabilities = ["Support ended"]; };
}
