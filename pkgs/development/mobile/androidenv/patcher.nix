{
  deployAndroidPackage,
  lib,
  package,
  os,
  arch,
  autoPatchelfHook,
  stdenv,
}:

deployAndroidPackage {
  inherit package os arch;
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  patchInstructions = lib.optionalString (os == "linux") ''
    autoPatchelf $packageBaseDir/bin
  '';
}
