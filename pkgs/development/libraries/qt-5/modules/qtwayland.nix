{ lib, qtModule, qtbase, qtquickcontrols, wayland, pkg-config, fetchpatch }:

qtModule {
  pname = "qtwayland";
  qtInputs = [ qtbase qtquickcontrols ];
  buildInputs = [ wayland ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" "bin" ];
  patches = [
    # NixOS-specific, ensure that app_id is correctly determined for
    # wrapped executables from `wrapQtAppsHook` (see comment in patch for further
    # context).  Beware: shared among different Qt5 versions.
    ./qtwayland-app_id.patch

    # Backport of https://codereview.qt-project.org/c/qt/qtwayland/+/388338
    # Pulled from Fedora as they modified it to not apply to KDE as Plasma 5.x
    # doesn't behave properly with the patch applied. See the discussion at
    # https://invent.kde.org/qt/qt/qtwayland/-/merge_requests/39 for details
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/qt5-qtwayland/raw/46376bb00d4c3dd3db2e82ad7ca5301ce16ea4ab/f/0080-Client-set-constraint-adjustments-for-popups-in-xdg.patch";
      sha256 = "sha256-XP+noYCk8fUdA0ItCqMjV7lSXDlNdB7Az9q7NRpupHc=";
    })
  ];
}
