{ akonadi
, akonadi-calendar
, akonadi-search
, boost
, calendarsupport
, cyrus_sasl
, eventviews
, extra-cmake-modules
, gpgmepp
, grantlee
, grantleetheme
, incidenceeditor
, kalarmcal
, kblog
, kcalcore
, kcalutils
, kcmutils
, kcontacts
, kdeApp
, kdelibs4support
, kdepim-apps-libs
, kdepimlibs
, kdgantt2
, kdnssd
, kdoctools
, kholidays
, kidentitymanagement
, kimap
, kldap
, kmailtransport
, kmbox
, kmime
, knewstuff
, knotifyconfig
, kontactinterface
, kpimtextedit
, kross
, ktexteditor
, ktnef
, kxmlrpcclient
, lib
, libgravatar
, libical
, libkdepim
, libkleo
, libksieve
, mailcommon
, mailimporter
, messagelib
, openldap
, pimcommon
, qt5
, syndication
}:

kdeApp {
  name = "kdepim";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    akonadi
    akonadi-calendar
    akonadi-search
    boost
    calendarsupport
    cyrus_sasl
    eventviews
    gpgmepp
    grantlee
    grantleetheme
    incidenceeditor
    kalarmcal
    kblog
    kcalcore
    kcalutils
    kcmutils
    kcontacts
    kdelibs4support
    kdepim-apps-libs
    kdepimlibs
    kdgantt2
    kdnssd
    kdoctools
    kholidays
    kidentitymanagement
    kimap
    kldap
    kmailtransport
    kmbox
    kmime
    knewstuff
    knotifyconfig
    kontactinterface
    kpimtextedit
    kross
    ktexteditor
    ktnef
    kxmlrpcclient
    libgravatar
    libical
    libkdepim
    libkleo
    libksieve
    mailcommon
    mailimporter
    messagelib
    openldap
    pimcommon
    qt5.qtwebengine
    qt5.qtx11extras
    syndication
  ];
  cmakeFlags = [ "-DQTWEBENGINE_EXPERIMENTAL_OPTION=True" ];
}
