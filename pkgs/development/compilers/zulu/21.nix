{ callPackage
, enableJavaFX ? false
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-21-lts&package=jdk
  # Note that the latest build may differ by platform
  dists = {
    x86_64-linux = {
      zuluVersion = "21.32.17";
      jdkVersion = "21.0.2";
      hash =
        if enableJavaFX then "sha256-CEM2lMjyZLWS1tBcS1tBTUxBwAyzW3vrpRWFVVSFVGY="
        else "sha256-Wtcw++5rtJv/8QvznoQ5LnKNiRA9NHSn5d7w/RNLMAo=";
    };

    aarch64-linux = {
      zuluVersion = "21.32.17";
      jdkVersion = "21.0.2";
      hash =
        if enableJavaFX then throw "JavaFX is not available for aarch64-linux"
        else "sha256-zn3xr11EqfRVYXxLiJFEP74+Syacd32Lgu1m93Fnz+A=";
    };

    x86_64-darwin = {
      zuluVersion = "21.32.17";
      jdkVersion = "21.0.2";
      hash =
        if enableJavaFX then "sha256-CbEKa9Z/ItFqVM4BqsWXyRf5ejQZXPK8OqkULr9Cpqk="
        else "sha256-Otj+KI61fZdcJ4auRToDaqRuR6sqw9gVOOuuKlTTwCU=";
    };

    aarch64-darwin = {
      zuluVersion = "21.32.17";
      jdkVersion = "21.0.2";
      hash =
        if enableJavaFX then "sha256-PK+cafgQsnK6acuQxun4IUiyYHQJsBfUawwfGV8OCfQ="
        else "sha256-6CYFFt6LYGYUIqcl8d8sNu+Ij2+zU5NWawDnMl2z0E4=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
