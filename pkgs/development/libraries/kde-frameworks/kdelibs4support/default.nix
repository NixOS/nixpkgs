{
  mkDerivation, lib, copyPathsToStore, fetchpatch,
  docbook_xml_dtd_45, extra-cmake-modules, kdoctools,
  kauth, karchive, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kcrash,
  kdbusaddons, kded, kdesignerplugin, kemoticons, kglobalaccel, kguiaddons,
  ki18n, kiconthemes, kio, kitemmodels, kinit, knotifications, kparts, kservice,
  ktextwidgets, kunitconversion, kwidgetsaddons, kwindowsystem, kxmlgui,
  networkmanager, qtbase, qtsvg, qttools, qtx11extras, xorg
}:

mkDerivation {
  name = "kdelibs4support";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series) ++ [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/OpenMandrivaAssociation/kdelibs4support/d101a02d6812ee65542ee36d0fd0f524be5c3fc1/kdelibs4support-5.32.0-openssl-1.1.patch";
      sha256 = "00jiy43hxkczmih4mirbmzbgc42sv15rnnm0kaar963s58pp6fy2";
    })
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
