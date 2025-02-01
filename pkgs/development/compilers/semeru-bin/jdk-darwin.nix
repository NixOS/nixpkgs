{ lib, callPackage }:

let
  sources = (lib.importJSON ./sources.json).openj9.mac;
  common = opts: callPackage (import ./jdk-darwin-base.nix opts) { };

in
# EOL = [ "This JDK/JRE version has reached End of Life." ];
{
  jdk-8 = common { sourcePerArch = sources.jdk.openjdk8; };
  jre-8 = common { sourcePerArch = sources.jre.openjdk8; };
  jdk-11 = common { sourcePerArch = sources.jdk.openjdk11; };
  jre-11 = common { sourcePerArch = sources.jre.openjdk11; };
  jdk-17 = common { sourcePerArch = sources.jdk.openjdk17; };
  jre-17 = common { sourcePerArch = sources.jre.openjdk17; };
  jdk-21 = common { sourcePerArch = sources.jdk.openjdk21; };
  jre-21 = common { sourcePerArch = sources.jre.openjdk21; };
}
