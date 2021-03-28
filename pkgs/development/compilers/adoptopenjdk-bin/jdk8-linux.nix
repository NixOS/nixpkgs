let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
in
{
  jdk-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk8.linux.jdk.hotspot; };
  jre-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk8.linux.jre.hotspot; };
  jdk-openj9 = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk8.linux.jdk.openj9; };
  jre-openj9 = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk8.linux.jre.openj9; };
}
