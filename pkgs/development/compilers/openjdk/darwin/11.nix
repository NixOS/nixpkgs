{ callPackage
, enableJavaFX ? false
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-11-lts&package=jdk
  # Note that the latest build may differ by platform
  dists = {
    x86_64-darwin = {
      zuluVersion = "11.66.15";
      jdkVersion = "11.0.20";
      hash =
        if enableJavaFX then "sha256-pVgCJkgYTlFeL7nkkMWLeJ/J8ELhgvWb7gzf3erZP7Y="
        else "sha256-vKqxHP5Yb651g8bZ0xHGQ4Q1T7JjjrmgEuykw/Gh2f0=";
    };

    aarch64-darwin = {
      zuluVersion = "11.66.15";
      jdkVersion = "11.0.20";
      hash =
        if enableJavaFX then "sha256-VoZo34SCUU+HHnTl6iLe0QBC+4VDkPP14N98oqSg9EQ="
        else "sha256-djK8Kfikt9SSuT87x1p7YWMIlNuF0TZFYDWrKiTTiIU=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
