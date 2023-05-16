{
<<<<<<< HEAD
  mkDerivation,
=======
  mkDerivation, lib,
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  extra-cmake-modules,
  qtbase, qttools, shared-mime-info
}:

<<<<<<< HEAD
mkDerivation {
=======
mkDerivation ({
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "kcoreaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools shared-mime-info ];
  propagatedBuildInputs = [ qtbase ];
<<<<<<< HEAD
}
=======
} // lib.optionalAttrs (lib.versionAtLeast qtbase.version "6") {
  dontWrapQtApps = true;
  cmakeFlags = [
    "-DBUILD_WITH_QT6=ON"
    "-DEXCLUDE_DEPRECATED_BEFORE_AND_AT=CURRENT"
  ];
  postInstall = ''
    moveToOutput "mkspecs" "$dev"
  '';
})
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
