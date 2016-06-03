{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, akonadi
, qtwebkit
, qtx11extras
, grantlee
, gpgme
, kdelibs4support
, kwallet
, knewstuff
, kcmutils
, kdewebkit
, knotifyconfig
, khtml
, phonon
, kdnssd
, ktexteditor
, kpimtextedit
}:

kdeApp {
  name = "kdepim";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  propagatedbuildInputs = [
    akonadi
    grantlee
    qtwebkit
    qtx11extras
    gpgme
    kdelibs4support
    kwallet
    knewstuff
    kcmutils
    kdewebkit
    knotifyconfig
    khtml
    phonon
    kdnssd
    ktexteditor
    kpimtextedit
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
