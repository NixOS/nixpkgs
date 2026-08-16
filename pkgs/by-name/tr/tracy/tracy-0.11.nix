{
  lib,
  stdenv,

  capstone,
}:

{
  version = "0.11.1";
  srcHash = "sha256-HofqYJT1srDJ6Y1f18h7xtAbI/Gvvz0t9f0wBNnOZK8=";
  patches = lib.optional (
    stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11"
  ) ./dont-use-the-uniformtypeidentifiers-framework.patch;
  extraBuildInputs = [
    capstone
  ];
}
