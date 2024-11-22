{
  mkDerivation,
  docbook_xml_dtd_45, extra-cmake-modules, kdoctools,
  kauth, karchive, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kcrash,
  kdbusaddons, kded, kdesignerplugin, kemoticons, kglobalaccel, kguiaddons,
  ki18n, kiconthemes, kio, kitemmodels, kinit, knotifications, kparts, kservice,
  ktextwidgets, kunitconversion, kwidgetsaddons, kwindowsystem, kxmlgui,
  networkmanager, qtbase, qtsvg, qttools, qtx11extras, xorg
}:

mkDerivation {
  pname = "kdelibs4support";
  patches = [
    ./nix-kde-include-dir.patch
  ];
  setupHook = ./setup-hook.sh;
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  propagatedNativeBuildInputs = [ kdoctools ];
  buildInputs = [
    kcompletion kconfig kded kglobalaccel ki18n kio kservice kwidgetsaddons
    kxmlgui networkmanager qtsvg qtx11extras xorg.libSM
  ];
  propagatedBuildInputs = [
    kauth karchive kconfigwidgets kcoreaddons kcrash kdbusaddons kdesignerplugin
    kemoticons kguiaddons kiconthemes kitemmodels kinit knotifications kparts
    ktextwidgets kunitconversion kwindowsystem qtbase
  ];
  cmakeFlags = [
    "-DDocBookXML4_DTD_DIR=${docbook_xml_dtd_45}/xml/dtd/docbook"
    "-DDocBookXML4_DTD_VERSION=4.5"
  ];
  outputs = [ "out" "dev" ];
}
