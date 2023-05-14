{
  mkDerivation, lib,
  extra-cmake-modules,
  boost, kactivities, kconfig, qtbase,
}:

mkDerivation {
  pname = "kactivities-stats";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ boost kactivities kconfig ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
  meta.platforms = lib.platforms.linux ++ lib.platforms.freebsd;
}
