let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
in
{
  jdk-hotspot = import ./jdk-darwin-base.nix sources.openjdk8.mac.jdk.hotspot;
  jre-hotspot = import ./jdk-darwin-base.nix sources.openjdk8.mac.jre.hotspot;
  jdk-openj9 = import ./jdk-darwin-base.nix sources.openjdk8.mac.jdk.openj9;
  jre-openj9 = import ./jdk-darwin-base.nix sources.openjdk8.mac.jre.openj9;
}
