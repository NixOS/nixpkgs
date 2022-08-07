{ lib }:

let
  sources = lib.importJSON ./sources.json;
in
{
  jdk-openj9 = import ./jdk-linux-base.nix { sourcePerArch = sources.semeru11.linux.jdk.openj9; };
  jre-openj9 = import ./jdk-linux-base.nix { sourcePerArch = sources.semeru11.linux.jre.openj9; };
}
