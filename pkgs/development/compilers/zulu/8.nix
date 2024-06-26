{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-8-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = "8.76.0.17";
        jdkVersion = "8.0.402";
        hash =
          if enableJavaFX then
            "sha256-29aDAu8WVYQFSpMUFq4gG64BBz/ei/VDMg72xrpB9w4="
          else
            "sha256-34DI6O7T8iqDHsX63S3xk+BKDu8IHRRWNvtxpsnUJEk=";
      };

      aarch64-linux = {
        zuluVersion = "8.74.0.17";
        jdkVersion = "8.0.392";
        hash =
          if enableJavaFX then
            throw "JavaFX is not available for aarch64-linux"
          else
            "sha256-xESdKEmfkiE657X/xclwsJR5M+P72BpWErtAcYMcK0Y=";
      };

      x86_64-darwin = {
        zuluVersion = "8.76.0.17";
        jdkVersion = "8.0.402";
        hash =
          if enableJavaFX then
            "sha256-oqFpKeWwfiXr3oX78LGvAyDGAAS2GON2gAm6fHGH7Ow="
          else
            "sha256-edZqDEsydQCDEwC1ZCDF/MjWVTnuQNWcKR2k/RjaIEI=";
      };

      aarch64-darwin = {
        zuluVersion = "8.76.0.17";
        jdkVersion = "8.0.402";
        hash =
          if enableJavaFX then
            "sha256-UCWRXCz4v381IWzWPDYzwJwbhsmZOYxKPLGJBQGjPmc="
          else
            "sha256-0VPlOuNB39gDnU+pK0DGTSUjTHTtYoxaRg3YD2LyLXg=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
