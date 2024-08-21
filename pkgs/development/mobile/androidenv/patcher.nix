{deployAndroidPackage, lib, package, os, autoPatchelfHook, stdenv}:

deployAndroidPackage {
  inherit package os;
  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  patchInstructions = lib.optionalString (os == "linux") ''
    autoPatchelf $packageBaseDir/bin
  '';
}
