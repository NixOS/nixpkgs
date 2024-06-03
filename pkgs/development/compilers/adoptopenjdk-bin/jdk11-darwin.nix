{ lib }:

let
  sources = import ./sources.nix;
in
{
  jdk-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk11.mac.jdk.hotspot; };
  jre-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk11.mac.jre.hotspot; };
  jdk-openj9 = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk11.mac.jdk.openj9; };
  jre-openj9 = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk11.mac.jre.openj9; };
}
