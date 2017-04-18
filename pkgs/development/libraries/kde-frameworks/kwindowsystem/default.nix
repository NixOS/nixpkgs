{
  kdeFramework, lib, copyPathsToStore,
  extra-cmake-modules,
  qtbase, qttools, qtx11extras
}:

kdeFramework {
  name = "kwindowsystem";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  propagatedBuildInputs = [ qtx11extras ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QT_PLUGIN_PATH=\"$out/lib/qt5/plugins\""
  '';
}
