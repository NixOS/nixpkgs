{ kdeFramework, lib, extra-cmake-modules, attica, kconfig
, kconfigwidgets, kglobalaccel, ki18n, kiconthemes, kitemviews
, ktextwidgets, kwindowsystem, sonnet
}:

kdeFramework {
  name = "kxmlgui";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    attica kconfig kiconthemes kitemviews ktextwidgets
  ];
  propagatedBuildInputs = [
    kconfigwidgets kglobalaccel ki18n kwindowsystem sonnet
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
