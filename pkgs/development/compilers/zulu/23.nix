{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-23&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = "23.28.85";
        jdkVersion = "23.0.0";
        hash =
          if enableJavaFX then
            "sha256-TfkuAYcj+D9P3lZKYcQMah8Y/gfNVnB4kaYyQQNdWkc="
          else
            "sha256-byvonJmkVVPwPLuqDPV5FX2A+KKoWn/9hYh+xpHckaI=";
      };

      aarch64-linux = {
        zuluVersion = "23.28.85";
        jdkVersion = "23.0.0";
        hash =
          if enableJavaFX then
            "sha256-4SQmkt8v2cC4qpDP4I1N/0BXHaEru9Tb1NGFYZRF+rc="
          else
            "sha256-7Jc1N3rdawWQ13leYEwN5+GvQCFuGtKzWuL7+dEMnDU=";
      };

      x86_64-darwin = {
        zuluVersion = "23.28.85";
        jdkVersion = "23.0.0";
        hash =
          if enableJavaFX then
            "sha256-yVAkX2uDZPe1Jf+tPkal9OBEREsC3xhuPEqXZqmKiLk="
          else
            "sha256-R5fB74KPaKaJamjL1LpDGSWn4Qb7K1Z3bldYpa513FY=";
      };

      aarch64-darwin = {
        zuluVersion = "23.28.85";
        jdkVersion = "23.0.0";
        hash =
          if enableJavaFX then
            "sha256-opQSE1QmxsilIlZMKaqzU1b8+m8P8/NrLJXNxlcxQTM="
          else
            "sha256-C510C53ijwDjgBDyY9eQ2at6BN9I6HqoNd2jxAlSmv8=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
