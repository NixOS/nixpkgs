{
  mkDerivation, lib,
  extra-cmake-modules,
  qtwebkit, plasma-framework, qtbase, kparts
}:

mkDerivation {
  name = "kdewebkit";
  meta = {
    maintainers = [ lib.maintainers.exi ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules kparts plasma-framework ];
  propagatedBuildInputs = [ qtwebkit ];
  outputs = [ "out" "dev" ];
}
