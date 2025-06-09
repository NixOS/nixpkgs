{
  mkDerivation,
  extra-cmake-modules,
  gettext,
  kdoctools,
  python3,
  appstream-qt,
  discount,
  flatpak,
  fwupd,
  ostree,
  pcre,
  util-linux,
  qtquickcontrols2,
  qtwebview,
  qtx11extras,
  karchive,
  kcmutils,
  kconfig,
  kcrash,
  kdbusaddons,
  kdeclarative,
  kidletime,
  kio,
  kirigami2,
  kitemmodels,
  knewstuff,
  kpurpose,
  kuserfeedback,
  kwindowsystem,
  kxmlgui,
  plasma-framework,
}:

mkDerivation {
  pname = "discover";
  nativeBuildInputs = [
    extra-cmake-modules
    gettext
    kdoctools
    python3
  ];
  buildInputs = [
    # discount is needed for libmarkdown
    appstream-qt
    discount
    flatpak
    fwupd
    ostree
    pcre
    util-linux
    qtquickcontrols2
    qtwebview
    qtx11extras
    karchive
    kcmutils
    kconfig
    kcrash
    kdbusaddons
    kdeclarative
    kidletime
    kio
    kirigami2
    kitemmodels
    knewstuff
    kpurpose
    kuserfeedback
    kwindowsystem
    kxmlgui
    plasma-framework
  ];

  # Incompatible with our current version of fwupd:
  # error: 'fwupd_release_get_uri' was not declared in this scope
  meta.broken = true;
}
