{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qttools, shared-mime-info
}:

mkDerivation ({
  pname = "kcoreaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools shared-mime-info ];
  propagatedBuildInputs = [ qtbase ];
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
