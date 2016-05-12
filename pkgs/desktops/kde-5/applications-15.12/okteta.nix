{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, qtscript
, kconfig
, kconfigwidgets
, kbookmarks
, kcodecs
, kcompletion
, kdbusaddons
, kiconthemes
, ki18n
, kcmutils
, kio
, knewstuff
, kparts
, kxmlgui
, shared_mime_info
, qca-qt5
}:

kdeApp {
  name = "okteta";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];

  buildInputs = [
    qtscript
    kconfig
    kconfigwidgets
    kbookmarks
    kcodecs
    kcompletion
    kdbusaddons
    kiconthemes
    ki18n
    kcmutils
    kio
    knewstuff
    kparts
    kxmlgui
    shared_mime_info
    qca-qt5
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/okteta"
  '';

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.ambrop72 ];
  };
}
