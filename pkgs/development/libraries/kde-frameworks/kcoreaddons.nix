{ kdeFramework, lib, fetchurl, extra-cmake-modules, qtbase, qttools, shared_mime_info }:

kdeFramework {
  name = "kcoreaddons";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [ shared_mime_info ];
}
