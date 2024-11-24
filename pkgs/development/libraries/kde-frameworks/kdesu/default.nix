{
  mkDerivation, lib,
  extra-cmake-modules,
  kcoreaddons, ki18n, kpty, kservice, qtbase,
  useSudo ? false
}:

mkDerivation {
  pname = "kdesu";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons ki18n kpty kservice qtbase ];
  propagatedBuildInputs = [ kpty ];
  outputs = [ "out" "dev" ];
  patches = [ ./kdesu-search-for-wrapped-daemon-first.patch ];
  cmakeFlags = lib.optionals useSudo [ "-DKDESU_USE_SUDO_DEFAULT=On" ];
  meta.platforms = lib.platforms.linux ++ lib.platforms.freebsd;
}
