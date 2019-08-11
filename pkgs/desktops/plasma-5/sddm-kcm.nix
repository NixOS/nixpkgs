{
  mkDerivation, extra-cmake-modules, shared-mime-info,
  libpthreadstubs, libXcursor, libXdmcp,
  qtquickcontrols2, qtx11extras,
  karchive, ki18n, kio, knewstuff
}:

mkDerivation {
  name = "sddm-kcm";
  nativeBuildInputs = [ extra-cmake-modules shared-mime-info ];
  buildInputs = [
    libpthreadstubs libXcursor libXdmcp
    qtquickcontrols2 qtx11extras
    karchive ki18n kio knewstuff
  ];
}
