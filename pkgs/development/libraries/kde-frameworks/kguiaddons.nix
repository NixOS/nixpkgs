{
  kdeFramework, lib,
  extra-cmake-modules,
  qtbase, qtx11extras,
}:

kdeFramework {
  name = "kguiaddons";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtx11extras ];
}
