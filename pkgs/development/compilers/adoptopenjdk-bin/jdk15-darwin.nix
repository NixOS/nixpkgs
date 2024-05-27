{ lib }:

let
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk15.mac.jdk.hotspot; knownVulnerabilities = [ "Support ended" ]; };
  jre-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk15.mac.jre.hotspot; knownVulnerabilities = [ "Support ended" ]; };
  jdk-openj9 = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk15.mac.jdk.openj9; knownVulnerabilities = [ "Support ended" ]; };
  jre-openj9 = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk15.mac.jre.openj9; knownVulnerabilities = [ "Support ended" ]; };
}
