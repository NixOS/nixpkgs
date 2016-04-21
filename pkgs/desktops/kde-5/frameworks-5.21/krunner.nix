{ kdeFramework, lib, extra-cmake-modules, kconfig, kcoreaddons
, ki18n, kio, kservice, plasma-framework, qtquick1, solid
, threadweaver
}:

kdeFramework {
  name = "krunner";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcoreaddons kservice qtquick1 solid threadweaver
  ];
  propagatedBuildInputs = [ ki18n kio plasma-framework ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
