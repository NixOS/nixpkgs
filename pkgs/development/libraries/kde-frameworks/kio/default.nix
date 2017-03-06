{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules, acl, karchive
, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons
, kdbusaddons, kdoctools, ki18n, kiconthemes, kitemviews
, kjobwidgets, knotifications, kservice, ktextwidgets, kwallet
, kwidgetsaddons, kwindowsystem, kxmlgui
, qtscript, qtx11extras, solid, fetchpatch
}:

kdeFramework {
  name = "kio";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    acl karchive kbookmarks kcompletion kconfig kconfigwidgets kcoreaddons
    kdbusaddons ki18n kiconthemes kitemviews kjobwidgets knotifications kservice
    ktextwidgets kwallet kwidgetsaddons kwindowsystem kxmlgui solid qtscript
    qtx11extras
  ];
  patches = (copyPathsToStore (lib.readPathsFromFile ./. ./series))
    ++ [
      (fetchpatch {
        name = "SanitizeURLsBeforePassingThemToFindProxyForURL.patch";
        url = "https://cgit.kde.org/kio.git/patch/?id=f9d0cb47cf94e209f6171ac0e8d774e68156a6e4";
        sha256 = "1s6rcp8rrlhc6rgy3b303y0qq0s8371n12r5lk9zbkw14wjvbix0";
      })
    ];
}
