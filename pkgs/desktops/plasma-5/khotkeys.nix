{ plasmaPackage, extra-cmake-modules, kdoctools, kcmutils
, kdbusaddons, kdelibs4support, kglobalaccel, ki18n, kio, kxmlgui
, plasma-framework, plasma-workspace, qtx11extras
, fetchpatch
}:

plasmaPackage {
  name = "khotkeys";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  patches = [
    # Patch is in 5.9 and up.
    (fetchpatch {
      url = "https://cgit.kde.org/khotkeys.git/patch/?id=f8f7eaaf41e2b95ebfa4b2e35c6ee252524a471b";
      sha256 = "1wxx3qv16jd623jh728xcda8i4y1daq25skwilhv4cfvqxyzk7nn";
    })
  ];
  propagatedBuildInputs = [
    kdelibs4support kglobalaccel ki18n kio plasma-framework plasma-workspace
    qtx11extras kcmutils kdbusaddons kxmlgui
  ];
}
