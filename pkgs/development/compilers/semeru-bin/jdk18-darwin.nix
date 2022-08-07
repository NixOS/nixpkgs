{ lib }:

let
  sources = lib.importJSON ./sources.json;
in
{
  jdk-openj9 = import ./jdk-darwin-base.nix { sourcePerArch = sources.semeru18.mac.jdk.openj9; };
  jre-openj9 = import ./jdk-darwin-base.nix { sourcePerArch = sources.semeru18.mac.jre.openj9; };
}
