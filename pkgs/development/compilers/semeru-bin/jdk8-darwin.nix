{ lib }:

let
  sources = lib.importJSON ./sources.json;
in
{
  jdk-openj9 = import ./jdk-darwin-base.nix { sourcePerArch = sources.semeru8.mac.jdk.openj9; };
  jre-openj9 = import ./jdk-darwin-base.nix { sourcePerArch = sources.semeru8.mac.jre.openj9; };
}
