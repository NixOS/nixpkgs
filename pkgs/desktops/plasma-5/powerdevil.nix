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
    # This fixes an issue where 'DDCA_Feature_List*' cannot be converted to
    # 'DDCA_Feature_List'.
    # This can be dropped with the next release.
    # https://bugs.kde.org/show_bug.cgi?id=423605
    (fetchpatch {
      url = "https://invent.kde.org/plasma/powerdevil/-/commit/fcb26be2fb279e6ad3b7b814d26a5921d16201eb.patch";
      sha256 = "0gdyaa0nd1c1d6x2h0m933lascm8zm5sikd99wxmkf7hhaby6k2s";
    })
    # This is a backport of
    # https://invent.kde.org/plasma/powerdevil/-/commit/c7590f9065ec9547b7fabad77a548bbc0c693113.patch,
    # which doesn't apply cleanly to 5.17.5.  It should make it into 5.20, so
    # this patch can be removed when we upgrade to 5.20.
    ./patches/0001-Add-a-logging-category-config-file.patch
  ];
}
