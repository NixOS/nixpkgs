{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  itstool,
  wrapGAppsHook4,
  glib,
  accountsservice,
  dbus,
  flatpak,
  malcontent,
  gtk4,
  libadwaita,
  appstream,
  desktop-file-utils,
  polkit,
  glib-testing,
}:

stdenv.mkDerivation {
  pname = "malcontent-ui";

  inherit (malcontent) version src;

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  patches = [
    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch

    # Do not build things that are part of malcontent package
    ./better-separation.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    itstool
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    dbus
    polkit
    glib-testing
    flatpak
  ];

  propagatedBuildInputs = [
    accountsservice
    malcontent
    glib
    gtk4
    libadwaita
  ];

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    "-Duse_system_libmalcontent=true"
    "-Dui=enabled"
  ];

  meta = with lib; {
    description = "UI components for parental controls library";
    mainProgram = "malcontent-control";
    homepage = "https://gitlab.freedesktop.org/pwithnall/malcontent";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
