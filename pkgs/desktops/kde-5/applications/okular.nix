{
  kdeApp, lib, kdeWrapper,
  ecm, kdoctools,
  djvulibre, ebook_tools, kactivities, karchive, kbookmarks, kcompletion,
  kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kdegraphics-mobipocket,
  kiconthemes, kjs, khtml, kio, kparts, kpty, kwallet, kwindowsystem, libkexiv2,
  libspectre, poppler, qca-qt5, qtdeclarative, qtsvg, threadweaver
}:

let
  unwrapped = kdeApp {
    name = "okular";
    nativeBuildInputs = [ ecm kdoctools ];
    propagatedBuildInputs = [
      djvulibre ebook_tools kactivities karchive kbookmarks kcompletion kconfig
      kconfigwidgets kcoreaddons kdbusaddons kdegraphics-mobipocket kiconthemes
      kjs khtml kio kparts kpty kwallet kwindowsystem libkexiv2 libspectre poppler
      qca-qt5 qtdeclarative qtsvg threadweaver
    ];
    meta = {
      platforms = lib.platforms.linux;
      homepage = "http://www.kde.org";
      license = with lib.licenses; [ gpl2 lgpl21 fdl12 bsd3 ];
      maintainers = [ lib.maintainers.ttuegel ];
    };
  };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/okular" ];
}
