{
  mkDerivation, lib,
  extra-cmake-modules,
  kcoreaddons, ki18n, kpty, kservice, qtbase,
}:

mkDerivation {
  pname = "kdesu";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons ki18n kpty kservice qtbase ];
  propagatedBuildInputs = [ kpty ];
  outputs = [ "out" "dev" ];
  patches = [ ./kdesu-search-for-wrapped-daemon-first.patch ];
  meta.platforms = lib.platforms.linux ++ lib.platforms.freebsd;
}
