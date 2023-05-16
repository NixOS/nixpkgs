{
<<<<<<< HEAD
  mkDerivation, lib, stdenv,
=======
  mkDerivation,
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  extra-cmake-modules, perl,
  karchive, kconfig, kguiaddons, ki18n, kiconthemes, kio, kparts, libgit2,
  qtscript, qtxmlpatterns, sonnet, syntax-highlighting, qtquickcontrols,
  editorconfig-core-c
}:

<<<<<<< HEAD
mkDerivation ({
=======
mkDerivation {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "ktexteditor";
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [
    karchive kconfig kguiaddons ki18n kiconthemes kio libgit2 qtscript
    qtxmlpatterns sonnet syntax-highlighting qtquickcontrols
    editorconfig-core-c
  ];
  propagatedBuildInputs = [ kparts ];
<<<<<<< HEAD
} // lib.optionalAttrs stdenv.isDarwin {
  postPatch = ''
    substituteInPlace src/part/CMakeLists.txt \
      --replace "kpart.desktop" "${kparts}/share/kservicetypes5/kpart.desktop"
  '';
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
