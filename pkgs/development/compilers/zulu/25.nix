{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For Zulu 25, FX and non-FX versions can differ
  zuluVersion = if enableJavaFX then "25.32.21" else "25.32.21";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-24&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion;
        jdkVersion = "25.0.2";
        hash =
          if enableJavaFX then
            "sha256-KpdyDAQxZjgftuHniElprJ2RSRB2eOwvQk1QaXxV+kk="
          else
            "sha256-lGrZdm2Y/Gq0laGhIAchl9tUmX9pJfuWaA8ezVWR204=";
      };

      aarch64-linux = {
        inherit zuluVersion;
        jdkVersion = "25.0.2";
        hash =
          if enableJavaFX then
            "sha256-kLusgsgOD2HVasawwjsDF6b8M4BxVO+Kzs/rta4IAnw="
          else
            "sha256-mQPGsZGDozclyh39rltyQAydAJlcdvr8Sg0xxRUvM/c=";
      };

      x86_64-darwin = {
        inherit zuluVersion;
        jdkVersion = "25.0.2";
        hash =
          if enableJavaFX then
            "sha256-8iIkfaV+BhEjdUrXMrOxg5XmcfJOLmHVFlE+UlKynzc="
          else
            "sha256-PT6eVE6g0bBCulI0RTPpIF74JyP/BXgCYsyxcayYDVU=";
      };

      aarch64-darwin = {
        inherit zuluVersion;
        jdkVersion = "25.0.2";
        hash =
          if enableJavaFX then
            "sha256-sGl624HftGDuwCfvgZLUaNJOBUQU9y6I1BLROL0HlPc="
          else
            "sha256-WZL+3hKV/d9uGc0HPCTmETW0L3n/v9pbzsVEIGJGoHk=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
