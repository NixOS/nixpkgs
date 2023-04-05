{ lib }:

let
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk17.mac.jdk.hotspot; };
  jre-hotspot = import ./jdk-darwin-base.nix { sourcePerArch = sources.openjdk17.mac.jre.hotspot; };
  jdk-openj9 = throw "openjdk17 on darwin is missing jdk-openj9";
  jre-openj9 = throw "openjdk17 on darwin is missing jre-openj9";
}
