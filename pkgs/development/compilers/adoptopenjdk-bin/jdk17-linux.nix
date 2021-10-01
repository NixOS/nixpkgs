let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
in
{
  jdk-hotspot = import ./jdk-linux-base.nix { sourcePerArch = sources.openjdk17.linux.jdk.hotspot; };
}
