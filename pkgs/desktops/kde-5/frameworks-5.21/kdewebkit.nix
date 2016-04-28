{ kdeFramework, lib, extra-cmake-modules, kconfig, kcoreaddons
, ki18n, kio, kjobwidgets, kparts, kservice, kwallet, qtwebkit
}:

kdeFramework {
  name = "kdewebkit";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kconfig kcoreaddons ki18n kio kjobwidgets kparts kservice kwallet qtwebkit
  ];
}
