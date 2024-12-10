{ stdenv, lib }:

let
  variant = if stdenv.hostPlatform.isMusl then "alpine_linux" else "linux";
  sources = lib.importJSON ./sources.json;
in
{
  jdk-hotspot = import ./jdk-linux-base.nix {
    sourcePerArch = sources.openjdk11.${variant}.jdk.hotspot;
  };
  jre-hotspot = import ./jdk-linux-base.nix {
    sourcePerArch = sources.openjdk11.${variant}.jre.hotspot;
  };
  jdk-openj9 = import ./jdk-linux-base.nix {
    sourcePerArch = sources.openjdk11.${variant}.jdk.openj9;
  };
  jre-openj9 = import ./jdk-linux-base.nix {
    sourcePerArch = sources.openjdk11.${variant}.jre.openj9;
  };
}
