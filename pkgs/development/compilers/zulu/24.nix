{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For 24 JDK FX can be different version than regular JDK
  zuluVersion = if enableJavaFX then "24.32.13" else "24.32.13";
  jdkVersion = "24.0.2";
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
            "sha256-6ZCa348yFLoZ70iDjNkN17dl1IWe53HxKMGpMhFuEOE="
          else
            "sha256-seZl5oZmHJlAFsOR6mFAvX9CEY+WatKIeYbi7W8RO/U=";
      };

      aarch64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-pVspe5R5INmEIJNiihDanOwleBklUp7Svj1NwzOe+ws="
          else
            "sha256-hV19g22QKWngOvNGh4dCaTOzLke6VjdsPCGQiVlyij0=";
      };

      x86_64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-JXsx8GvjPEQO9ZN3p+CraSWeqc0KDIRBado+jz7l2ww="
          else
            "sha256-UHY+Oy6g98bVk5BTfd/Mx3OT5He9SnWUR0L+LZso3Lo=";
      };

      aarch64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-Z825S6qxHMm3kwHQnu15dihguDOrxlM1lca3wU8lCqk="
          else
            "sha256-jDHoPG4NpNXVK35yNHe5JBkmaKNAixmmMEE0P9jcfnU=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
