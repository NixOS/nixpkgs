{ kdeApp
, lib
, extra-cmake-modules
, qtdeclarative
, cups
, kconfig
, kconfigwidgets
, kdbusaddons
, kiconthemes
, ki18n
, kcmutils
, kio
, knotifications
, plasma-framework
, kwidgetsaddons
, kwindowsystem
, kitemviews
}:

kdeApp {
  name = "print-manager";
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    cups kconfig kconfigwidgets kdbusaddons kiconthemes kcmutils knotifications
    kwidgetsaddons kitemviews ki18n kio kwindowsystem plasma-framework
    qtdeclarative
  ];
}
