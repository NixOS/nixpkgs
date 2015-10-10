{ kdeFramework, lib, extra-cmake-modules, attica, kconfig
, kconfigwidgets, kglobalaccel, ki18n, kiconthemes, kitemviews
, ktextwidgets, kwindowsystem, sonnet
}:

kdeFramework {
  name = "kxmlgui";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    attica kconfig kconfigwidgets kiconthemes kitemviews
    ktextwidgets sonnet
  ];
  propagatedBuildInputs = [ kglobalaccel ki18n kwindowsystem ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
