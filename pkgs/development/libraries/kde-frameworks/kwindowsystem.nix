{
  kdeFramework, lib,
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
}
