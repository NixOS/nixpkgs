{
  mkDerivation, lib, stdenv,
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
} // lib.optionalAttrs stdenv.isDarwin {
  # https://invent.kde.org/frameworks/kcoreaddons/-/merge_requests/327
  env.NIX_CFLAGS_COMPILE = "-DSOCK_CLOEXEC=0";
})
