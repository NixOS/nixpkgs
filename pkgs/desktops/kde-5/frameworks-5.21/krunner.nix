{ kdeFramework, lib, extra-cmake-modules, kconfig, kcoreaddons
, ki18n, kio, kservice, plasma-framework, qtquick1, solid
, threadweaver
}:

kdeFramework {
  name = "krunner";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kconfig kcoreaddons ki18n kio kservice plasma-framework qtquick1 solid
    threadweaver
  ];
}
