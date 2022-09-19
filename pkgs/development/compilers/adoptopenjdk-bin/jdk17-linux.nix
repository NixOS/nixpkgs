{ lib }:

let
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk17.linux.jdk.hotspot; };
  jre-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk17.linux.jre.hotspot; };
}
