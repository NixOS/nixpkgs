{ kdeFramework, lib, extra-cmake-modules, kcompletion, kconfig
, kconfigwidgets, ki18n, kiconthemes, kservice, kwindowsystem
, sonnet
}:

kdeFramework {
  name = "ktextwidgets";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcompletion kconfig kconfigwidgets kiconthemes kservice
  ];
  propagatedBuildInputs = [ ki18n kwindowsystem sonnet ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
