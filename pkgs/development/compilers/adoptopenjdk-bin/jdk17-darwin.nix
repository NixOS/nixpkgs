{ lib }:

let
  sources = import ./sources.nix;
in
{
  jdk-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk17.mac.jdk.hotspot; };
  jre-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk17.mac.jre.hotspot; };
}
