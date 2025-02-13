{
  deployAndroidPackage,
  lib,
  package,
  os,
  autoPatchelfHook,
  stdenv,
}:

deployAndroidPackage {
  inherit package os;
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  patchInstructions = lib.optionalString (os == "linux") ''
    autoPatchelf $packageBaseDir/bin
  '';
}
