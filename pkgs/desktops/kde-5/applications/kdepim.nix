{ akonadi
, akonadi-calendar
, akonadi-contacts
, akonadi-mime
, akonadi-notes
, akonadi-search
, boost
, calendarsupport
, cyrus_sasl
, eventviews
, ecm
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
, kdepim-runtime
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
    description = "KDE PIM tools";
    longDescription = ''
      Contains various personal information management tools for KDE, such as an organizer.
    '';
    license = with lib.licenses; [ gpl2 ];
    homepage = http://pim.kde.org;
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    ecm
  ];
  buildInputs = [
    akonadi
    akonadi-calendar
    akonadi-contacts
    akonadi-mime
    akonadi-notes
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
  propagatedUserEnvPkgs = [ akonadi kdepim-runtime ];
}
