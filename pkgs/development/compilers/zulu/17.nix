{ callPackage
, enableJavaFX ? false
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-17-lts&package=jdk
  # Note that the latest build may differ by platform
  dists = {
    x86_64-linux = {
      zuluVersion = "17.44.53";
      jdkVersion = "17.0.8.1";
      hash =
        if enableJavaFX then "sha256-R6VJcSjpKFfsO3l32+8s+wlcuAVoXcSsW5Dg2M/hjpI="
        else "sha256-uUgvIwShpophTfrN3PKVaacvD6wy5sdPg9wbmhV7g0A=";
    };

    aarch64-linux = {
      zuluVersion = "17.44.53";
      jdkVersion = "17.0.8.1";
      hash =
        if enableJavaFX then throw "JavaFX is not available for aarch64-linux"
        else "sha256-ZTHO9h5BbVp7aRVVyM8r3/aJIBuKAB/0WrZ0AGK0QxM=";
    };

    x86_64-darwin = {
      zuluVersion = "17.44.53";
      jdkVersion = "17.0.8.1";
      hash =
        if enableJavaFX then "sha256-9U0XYZRA+LZTQ7eHrT5SWhgcxv43ajC9n9Tj3qPPLWA="
        else "sha256-ZART6K/o/+D7Tc60U1+1DbnCg8ZGZe67C6aLGeZfSx8=";
    };

    aarch64-darwin = {
      zuluVersion = "17.44.53";
      jdkVersion = "17.0.8.1";
      hash =
        if enableJavaFX then "sha256-udYW3nOADclWqVcVtS9dgjSY0w6xf2nsBpLzPmQCYlI="
        else "sha256-MUsEVo7Arps2ugPJy9Qq3J4SZfdGeJI7GSl9ZuuE3Mo=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
