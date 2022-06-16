{
  mkDerivation, fetchpatch,
  extra-cmake-modules, kdoctools,
  bluez-qt, kactivities, kauth, kconfig, kdbusaddons,
  kglobalaccel, ki18n, kidletime, kio, knotifyconfig, kwayland, libkscreen,
  networkmanager-qt, plasma-workspace, qtx11extras, solid, udev
}:

mkDerivation {
  pname = "powerdevil";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  patches = [
    # Backported fix for https://bugs.kde.org/show_bug.cgi?id=454161
    # FIXME: remove for next release
    (fetchpatch {
      name = "brightness-overflow-fix";
      url = "https://invent.kde.org/plasma/powerdevil/-/commit/2ebe655d220c9167b66893a823b2fff2e2b8a531.patch";
      sha256 = "sha256-Sf2q0CImLYjy1fTp9AWbCeRG05liUkemhfEXL/0MIQI=";
    })
  ];
  buildInputs = [
    kconfig kdbusaddons knotifyconfig solid udev bluez-qt kactivities kauth
    kglobalaccel ki18n kio kidletime kwayland libkscreen
    networkmanager-qt plasma-workspace qtx11extras
  ];
}
