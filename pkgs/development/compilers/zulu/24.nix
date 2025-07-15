{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For 24 JDK FX can be different version than regular JDK
  zuluVersion = if enableJavaFX then "24.30.13" else "24.32.13";
  jdkVersion = if enableJavaFX then "24.0.1" else "24.0.2";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-24&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-jbpWNE+X5GJABQERq126ediyzGRQE9NZy9oMW/sPUa0="
          else
            "sha256-seZl5oZmHJlAFsOR6mFAvX9CEY+WatKIeYbi7W8RO/U=";
      };

      aarch64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-N9VOweloyX/2bFPH3L+Iw7nTkbiE7LvDNnTNM1b8Ghc="
          else
            "sha256-hV19g22QKWngOvNGh4dCaTOzLke6VjdsPCGQiVlyij0=";
      };

      x86_64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-c6Gwj8ol2YLfo4sMeCMGfYQvtDz7029L0Yj1dqVQvsw="
          else
            "sha256-UHY+Oy6g98bVk5BTfd/Mx3OT5He9SnWUR0L+LZso3Lo=";
      };

      aarch64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-Sac+DxNyGqsiStpc/wZYd2K7rvPEjo901kOYERYi+Sw="
          else
            "sha256-jDHoPG4NpNXVK35yNHe5JBkmaKNAixmmMEE0P9jcfnU=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
