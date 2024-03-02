{ lib }:

let
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk17.mac.jdk.hotspot; };
  jre-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk17.mac.jre.hotspot; };
}
