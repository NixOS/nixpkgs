{ kdeApp, lib
, extra-cmake-modules, kdoctools
, shared_mime_info
, exiv2
, karchive
, kbookmarks
, kconfig, kconfigwidgets
, kcoreaddons, kdbusaddons, kguiaddons
, kdnssd
, kiconthemes
, ki18n
, kio
, khtml
, kdelibs4support
, kpty
, libmtp
, libssh
, openexr
, openslp
, phonon
, qtsvg
, samba
, solid
}:

kdeApp {
  name = "kio-extras";
  nativeBuildInputs = [
    extra-cmake-modules kdoctools
    shared_mime_info
  ];
  buildInputs = [
    exiv2
    karchive
    kbookmarks
    kconfig kconfigwidgets
    kcoreaddons kdbusaddons kguiaddons
    kdnssd
    kiconthemes
    ki18n
    kio
    khtml
    kdelibs4support
    kpty
    libmtp
    libssh
    openexr
    openslp
    phonon
    qtsvg
    samba
    solid
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
