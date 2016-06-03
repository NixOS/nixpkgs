{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, akonadi
, shared_mime_info
, qtxmlpatterns
, qtwebkit
, kdelibs4support
, knotifyconfig
, kross
}:

kdeApp {
  name = "kdepim-runtime";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  propagatedbuildInputs = [
    akonadi
    shared_mime_info
    qtxmlpatterns
    qtwebkit
    kdelibs4support
    knotifyconfig
    kross
  ];

  postInstall = ''
    ls -l $out/bin
    wrapQtProgram "$out/bin/kcalc"
  '';

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
