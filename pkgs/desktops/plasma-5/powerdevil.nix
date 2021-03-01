{
  mkDerivation, fetchpatch,
  extra-cmake-modules, kdoctools,
  bluez-qt, kactivities, kauth, kconfig, kdbusaddons, kdelibs4support,
  kglobalaccel, ki18n, kidletime, kio, knotifyconfig, kwayland, libkscreen,
  ddcutil, networkmanager-qt, plasma-workspace, qtx11extras, solid, udev
}:

mkDerivation {
  name = "powerdevil";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kdbusaddons knotifyconfig solid udev bluez-qt kactivities kauth
    kdelibs4support kglobalaccel ki18n kio kidletime kwayland libkscreen
    networkmanager-qt plasma-workspace qtx11extras
    ddcutil
  ];
  cmakeFlags = [
    "-DHAVE_DDCUTIL=On"
  ];
  patches = [
    # Reduce log message spam by setting the default log level to Warning.
    #(fetchpatch {
    #  url = "https://invent.kde.org/plasma/powerdevil/-/commit/c7590f9065ec9547b7fabad77a548bbc0c693113.patch";
    #  sha256 = "077whhi0jrb3bajx357k7n66hv7nchis8jix0nfc1zjvi9fm6pi2";
    #})
  ];
}
