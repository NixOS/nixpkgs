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
, kdeWrapper
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
, qtwebengine
, qtx11extras
, syndication
}:

let
  unwrapped =
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
        akonadi.unwrapped
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
        qtwebengine
        qtx11extras
        syndication
      ];
      propagatedUserEnvPkgs = [ akonadi ];
      postInstall = ''
        ln -s ${qtwebengine}/libexec/QtWebEngineProcess $out/bin
        ln -s ${qtwebengine}/resources/icudtl.dat $out/bin
        ln -s ${qtwebengine}/resources/qtwebengine_resources.pak $out/bin
        ln -s ${qtwebengine}/resources/qtwebengine_resources_100p.pak $out/bin
        ln -s ${qtwebengine}/resources/qtwebengine_resources_200p.pak $out/bin
        ln -s ${qtwebengine}/translations/qtwebengine_locales $out/bin
      '';
    };
in
kdeWrapper unwrapped
{
  targets = [
    "bin/akregator"
    "bin/blogilo"
    "bin/kaddressbook"
    "bin/kalarm"
    "bin/kmail"
    "bin/knotes"
    "bin/kontact"
    "bin/korganizer"
    "bin/sieveeditor"
    "bin/akonadiconsole"
  ];
  paths = [ kdepim-runtime ];
}
