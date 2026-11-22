{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For Zulu 27, FX and non-FX versions can differ
  zuluVersion = if enableJavaFX then "27.28.103" else "27.28.101";
  jdkVersion = "27.0.0";
  # The November security update is available for the plain Linux JDK.
  linuxZuluVersion = if enableJavaFX then zuluVersion else "27.30.201";
  linuxJdkVersion = if enableJavaFX then jdkVersion else "27.0.1.1";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-27&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = linuxZuluVersion;
        jdkVersion = linuxJdkVersion;
        hash =
          if enableJavaFX then
            "sha256:19wgslvpcz2jk8gwc4gb5y09cssn1s2cakjfm65ilh1wfdpdrpsj"
          else
            "sha256-xNe/TICiHpNRh+zcsRHksvFOH90YNkl0/n99pUsSvqA=";
      };

      aarch64-linux = {
        zuluVersion = linuxZuluVersion;
        jdkVersion = linuxJdkVersion;
        hash =
          if enableJavaFX then
            "sha256:0rwrn0k0wrd4c4x8kcpg4y5w85vy0yi7plfdw0adrqwpnzskbzbm"
          else
            "sha256-GIdbkq0lNSMKExdfcYkz98wFk7Sv+i2rRCgV7CRdrLs=";
      };

      aarch64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256:09rbmk80cyzajsq635gq1fvz4ll7v1yjcbx1yv7zp13iqhmiyck8"
          else
            "sha256:01wdi9s09dkv96cdv81awigp51x9lblb37j9jnyqx4zs28civ3qd";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
