{ lib }:

let
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk15.linux.jdk.hotspot; };
  jre-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk15.linux.jre.hotspot; };
  jdk-openj9 = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk15.linux.jdk.openj9; };
  jre-openj9 = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk15.linux.jre.openj9; };
}
