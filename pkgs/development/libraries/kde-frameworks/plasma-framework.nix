{
  mkDerivation, fetchpatch,
  extra-cmake-modules, kdoctools,
  kactivities, karchive, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdeclarative, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio,
  knotifications, kpackage, kservice, kwayland, kwindowsystem, kxmlgui,
  qtbase, qtdeclarative, qtscript, qtx11extras, kirigami2, qtquickcontrols2
}:

mkDerivation {
  pname = "plasma-framework";
  patches = [
    # FIXME: remove on kf5.96
    (fetchpatch {
      name = "fix-thumbnails-task-manager.patch";
      url = "https://invent.kde.org/frameworks/plasma-framework/-/commit/dff1b034c1162062aa2292099d3d01fc53dafdf6.patch";
      sha256 = "sha256-0162bi3J5bl5BmmUSrhxxy8MpLtSXkdHGK8wMcS5BB8=";
    })
  ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kactivities karchive kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio knotifications
    kwayland kwindowsystem kxmlgui qtdeclarative qtscript qtx11extras kirigami2
    qtquickcontrols2
  ];
  propagatedBuildInputs = [ kpackage kservice qtbase ];
}
