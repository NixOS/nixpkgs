{ kdeFramework, lib, ecm, attica, kconfig
, kconfigwidgets, kglobalaccel, ki18n, kiconthemes, kitemviews
, ktextwidgets, kwindowsystem, sonnet
}:

kdeFramework {
  name = "kxmlgui";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    attica kconfig kconfigwidgets kglobalaccel ki18n kiconthemes kitemviews
    ktextwidgets kwindowsystem sonnet
  ];
}
