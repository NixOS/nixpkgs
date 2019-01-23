let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
in
{
  jdk-hotspot = import ./jdk-darwin-base.nix sources.openjdk11.mac.jdk.hotspot;
  jre-hotspot = import ./jdk-darwin-base.nix sources.openjdk11.mac.jre.hotspot;
  jdk-openj9 = import ./jdk-darwin-base.nix sources.openjdk11.mac.jdk.openj9;
  # openj9 jre builds are currently missing: https://github.com/AdoptOpenJDK/openjdk-build/issues/796
  #jre-openj9 = import ./jdk-darwin-base.nix sources.openjdk11.mac.jre.openj9;
}
