{ lib, stdenv
, meson
, ninja
, pkg-config
, gobject-introspection
, itstool
, wrapGAppsHook
, glib
, accountsservice
, dbus
, flatpak
, malcontent
, gtk3
, appstream-glib
, desktop-file-utils
, polkit
, glib-testing
}:

stdenv.mkDerivation rec {
  pname = "malcontent-ui";

  inherit (malcontent) version src;

  outputs = [ "out" "lib" "dev" ];

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
    wrapGAppsHook
  ];

  buildInputs = [
    appstream-glib
    dbus
    polkit
    glib-testing
    flatpak
  ];

  propagatedBuildInputs = [
    accountsservice
    malcontent
    glib
    gtk3
  ];

  mesonFlags = [
    "-Dinstalled_tests=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    "-Duse_system_libmalcontent=true"
    "-Dui=enabled"
  ];

  meta = with lib; {
    description = "UI components for parental controls library";
    homepage = "https://gitlab.freedesktop.org/pwithnall/malcontent";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
