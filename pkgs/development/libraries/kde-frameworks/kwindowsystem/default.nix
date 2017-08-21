{
  mkDerivation, lib, copyPathsToStore,
  extra-cmake-modules,
  qtbase, qttools, qtx11extras
}:

mkDerivation {
  name = "kwindowsystem";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools qtx11extras ];
  propagatedBuildInputs = [ qtbase ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QT_PLUGIN_PATH=\"''${!outputBin}/$qtPluginPrefix\""
  '';
  outputs = [ "out" "dev" ];
}
