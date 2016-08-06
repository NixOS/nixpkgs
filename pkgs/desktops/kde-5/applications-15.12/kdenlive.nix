{ kdeApp
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
, kjobwidgets
, kio
, kparts
, ktexteditor
, kwindowsystem
, kxmlgui
, kdbusaddons
, kwallet
, plasma-framework
, kitemmodels
, knotifications
, threadweaver
, knewstuff
, karchive
, knotifyconfig
, kplotting
, ktextwidgets
, mlt
, shared_mime_info
, libv4l
}:

kdeApp {
  name = "kdenlive";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    qtscript
    #kconfig
    #kcrash
    kguiaddons
    kiconthemes
    #kinit
    #kjobwidgets
    #kparts
    #kxmlgui
    kdbusaddons
    #kwallet
    #kitemmodels
    knotifications
    #threadweaver
    knewstuff
    #libgit2
    karchive
    knotifyconfig
    kplotting
    ktextwidgets
    mlt
    shared_mime_info
    libv4l
  ];
  propagatedBuildInputs = [
    #kactivities
    #ki18n
    #kio
    #ktexteditor
    #kwindowsystem
    plasma-framework
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kdenlive"
  '';
  enableParallelBuilding = true;
  meta = {
    license = with lib.licenses; [ gpl3 lgpl3 lgpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
