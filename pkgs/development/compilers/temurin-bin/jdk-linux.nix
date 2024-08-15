{ stdenv, lib, callPackage }:

let
  variant = if stdenv.hostPlatform.isMusl then "alpine-linux" else "linux";
  sources = (lib.importJSON ./sources.json).hotspot.${variant};
  common = opts: callPackage (import ./jdk-linux-base.nix opts) { };

  # EOL = [ "This JDK version has reached End of Life." ];
in
{
  jdk-8 = common { sourcePerArch = sources.jdk.openjdk8; };
  jre-8 = common { sourcePerArch = sources.jre.openjdk8; };

  jdk-11 = common { sourcePerArch = sources.jdk.openjdk11; };
  jre-11 = common { sourcePerArch = sources.jre.openjdk11; };

  jdk-17 = common { sourcePerArch = sources.jdk.openjdk17; };
  jre-17 = common { sourcePerArch = sources.jre.openjdk17; };

  jdk-21 = common { sourcePerArch = sources.jdk.openjdk21; };
  jre-21 = common { sourcePerArch = sources.jre.openjdk21; };

  jdk-22 = common { sourcePerArch = sources.jdk.openjdk22; };
  jre-22 = common { sourcePerArch = sources.jre.openjdk22; };
}
