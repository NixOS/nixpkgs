{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-11-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = "11.70.15";
        jdkVersion = "11.0.22";
        hash =
          if enableJavaFX then
            "sha256-FxTHgng7/oDY3n3qy8j1ztbpBQeoGcEBJbEXqaE4Zr4="
          else
            "sha256-V41ZRrJtkle3joKhwoID5bvWkN5I4gFjmbEnTD7no8U=";
      };

      aarch64-linux = {
        zuluVersion = "11.70.15";
        jdkVersion = "11.0.22";
        hash =
          if enableJavaFX then
            throw "JavaFX is not available for aarch64-linux"
          else
            "sha256-u6XWMXAArUhMMb6j3KFOhkIxpVYR1oYLF0Wde7/tI0k=";
      };

      x86_64-darwin = {
        zuluVersion = "11.70.15";
        jdkVersion = "11.0.22";
        hash =
          if enableJavaFX then
            "sha256-JkJZwk+D28wHWqwUoLo7WW5ypwTrT5biSoP+70YI3eQ="
          else
            "sha256-ca/ttkPe2tbcm1ruguDgPsxKWbEdKcICsKCDXaup9N4=";
      };

      aarch64-darwin = {
        zuluVersion = "11.70.15";
        jdkVersion = "11.0.22";
        hash =
          if enableJavaFX then
            "sha256-bAgH4lCxPvvFOeif5gI2aoLt1aC4EXPzb2YmiS9bQsU="
          else
            "sha256-PWQOF+P9djZarjAJaE3I0tuI1E4H/9584VN04BMzmvM=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
