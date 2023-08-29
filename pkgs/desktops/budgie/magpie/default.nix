{ fetchFromGitHub
, runCommand
, lib
, fetchpatch
, stdenv
, pkg-config
, gnome
, gettext
, gobject-introspection
, cairo
, colord
, lcms2
, pango
, json-glib
, libstartup_notification
, libcanberra
, ninja
, xvfb-run
, xkeyboard_config
, libxcvt
, libxkbfile
, libXdamage
, libxkbcommon
, libXtst
, libinput
, libdrm
, gsettings-desktop-schemas
, glib
, gtk3
, gnome-desktop
, pipewire
, libgudev
, libwacom
, mesa
, meson
, xorgserver
, python3
, wrapGAppsHook
, gi-docgen
, sysprof
, libsysprof-capture
, desktop-file-utils
, libcap_ng
, graphene
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "magpie";
  version = "0.9.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "magpie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-A8FmW2o2p5B5pxTZ6twwufyhfppuMXjnMKopZRD+XdE=";
  };

  patches = [
    # Fix build with separate sysprof.
    # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2572
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/285a5a4d54ca83b136b787ce5ebf1d774f9499d5.patch";
      sha256 = "/npUE3idMSTVlFptsDpZmGWjZ/d2gqruVlJKq4eF4xU=";
    })
  ];

  mesonFlags = [
    "-Degl_device=true"
    "-Dprofiler=true"
    "-Ddocs=true"
    "-Dwith_shared_components=true"
  ];

  propagatedBuildInputs = [
    # required for pkg-config to detect magpie-clutter
    json-glib
    libXtst
    libcap_ng
    graphene
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxcvt
    mesa # needed for gbm
    meson
    ninja
    xvfb-run
    pkg-config
    python3
    wrapGAppsHook
    gi-docgen
    xorgserver
  ];

  buildInputs = [
    cairo
    glib
    gnome-desktop
    gnome.gnome-settings-daemon
    gobject-introspection
    gsettings-desktop-schemas
    gtk3
    libcanberra
    libdrm
    libgudev
    libinput
    libstartup_notification
    libwacom
    libxkbcommon
    libxkbfile
    libXdamage
    colord
    lcms2
    pango
    pipewire
    sysprof # for D-Bus interfaces
    libsysprof-capture
    xkeyboard_config
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
    # Magpie does not install any .desktop files
    substituteInPlace scripts/mesonPostInstall.sh --replace "update-desktop-database" "# update-desktop-database"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    # TODO: Move this into a directory devhelp can find.
    moveToOutput "share/magpie-0/doc" "$devdoc"
  '';

  # Install udev files into our own tree.
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  separateDebugInfo = true;

  passthru = {
    libdir = "${finalAttrs.finalPackage}/lib/magpie-0";

    tests = {
      libdirExists = runCommand "magpie-libdir-exists" {} ''
        if [[ ! -d ${finalAttrs.finalPackage.libdir} ]]; then
          echo "passthru.libdir should contain a directory, “${finalAttrs.finalPackage.libdir}” is not one."
          exit 1
        fi
        touch $out
      '';
    };
  };

  meta = with lib; {
    description = "Softish fork of Mutter 43.x";
    homepage = "https://github.com/BuddiesOfBudgie/magpie";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ federicoschonborn ];
    platforms = platforms.linux;
  };
})
