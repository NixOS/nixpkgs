{
  mkDerivation,
  extra-cmake-modules,
  shared-mime-info,
  libpthreadstubs,
  libXcursor,
  libXdmcp,
  qtquickcontrols2,
  qtx11extras,
  karchive,
  kcmutils,
  kdeclarative,
  ki18n,
  kio,
  knewstuff,
}:

mkDerivation {
  pname = "sddm-kcm";
  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info
  ];
  buildInputs = [
    libpthreadstubs
    libXcursor
    libXdmcp
    qtquickcontrols2
    qtx11extras
    karchive
    kcmutils
    kdeclarative
    ki18n
    kio
    knewstuff
  ];
}
