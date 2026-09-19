{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For Zulu 25, FX and non-FX versions can differ
  zuluVersion = if enableJavaFX then " 27.28.103" else "27.28.101";
  jdkVersion = "27.0.0";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-27&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256:19wgslvpcz2jk8gwc4gb5y09cssn1s2cakjfm65ilh1wfdpdrpsj"
          else
            "sha256:0rq26lvvpz70xkapvnjczdprxbvd5jma4a9d7k0drpxyxp21bg6c";
      };

      aarch64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256:0rwrn0k0wrd4c4x8kcpg4y5w85vy0yi7plfdw0adrqwpnzskbzbm"
          else
            "sha256:0f5sib00gy3v4h36iwhizvsdlq1b4ajw7k8z2103ii43ay3bz9cz";
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
