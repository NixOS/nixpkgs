{ kdeApp
, kdeWrapper
, lib
, extra-cmake-modules
, kdoctools
, qtscript
, kactivities
, kconfig
, kcrash
, kguiaddons
, kiconthemes
, ki18n
, kinit
, kio
, kio-extras
, kwindowsystem
, kdbusaddons
, plasma-framework
, knotifications
, knewstuff
, karchive
, knotifyconfig
, kplotting
, ktextwidgets
, mlt
, shared_mime_info
, libv4l
, kfilemetadata
, ffmpeg
, phonon-backend-vlc
, qtquickcontrols
}:

let
unwrapped = kdeApp {
  name = "kdenlive";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    qtscript
    kconfig
    kcrash
    kguiaddons
    kiconthemes
    kinit
    kdbusaddons
    knotifications
    knewstuff
    karchive
    knotifyconfig
    kplotting
    ktextwidgets
    mlt
    shared_mime_info
    libv4l
    ffmpeg
  ];
  propagatedBuildInputs = [
    kactivities
    ki18n
    kio
    kio-extras
    kwindowsystem
    kfilemetadata
    plasma-framework
    phonon-backend-vlc
    qtquickcontrols
  ];
  enableParallelBuilding = true;
  meta = {
    license = with lib.licenses; [ gpl2Plus ];
  };
};
in
kdeWrapper unwrapped
{
  targets = [ "bin/kdenlive" ];
  paths = [ kinit ];
}
