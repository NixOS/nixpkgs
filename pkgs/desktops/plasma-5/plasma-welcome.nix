{ mkDerivation
, extra-cmake-modules
, qtquickcontrols2
, accounts-qt
, kaccounts-integration
, kcoreaddons
, kconfigwidgets
, kdbusaddons
, kdeclarative
, ki18n
, kio
, kirigami2
, knewstuff
, knotifications
, kservice
, kuserfeedback
, kwindowsystem
, plasma-framework
, signond
}:

mkDerivation {
  pname = "plasma-welcome";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtquickcontrols2
    accounts-qt
    kaccounts-integration
    kcoreaddons
    kconfigwidgets
    kdbusaddons
    kdeclarative
    ki18n
    kio
    kirigami2
    knewstuff
    knotifications
    kservice
    kuserfeedback
    kwindowsystem
    plasma-framework
    signond
  ];
}
