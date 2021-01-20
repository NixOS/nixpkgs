{
  mkDerivation, lib, extra-cmake-modules, shared-mime-info,
  libpthreadstubs, libXcursor, libXdmcp,
  qtbase, qtquickcontrols2, qtx11extras,
  karchive, ki18n, kio, knewstuff
}:

mkDerivation {
  name = "sddm-kcm";
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
  nativeBuildInputs = [ extra-cmake-modules shared-mime-info ];
  buildInputs = [
    libpthreadstubs libXcursor libXdmcp
    qtquickcontrols2 qtx11extras
    karchive ki18n kio knewstuff
  ];
}
