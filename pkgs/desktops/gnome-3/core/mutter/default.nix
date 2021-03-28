{ fetchurl
, fetchpatch
, substituteAll
, runCommand
, lib, stdenv
, pkg-config
, gnome3
, gettext
, gobject-introspection
, cairo
, pango
, json-glib
, libstartup_notification
, zenity
, libcanberra
, ninja
, xkeyboard_config
, libxkbfile
, libxkbcommon
, libXtst
, libinput
, gsettings-desktop-schemas
, glib
, gtk3
, gnome-desktop
, pipewire
, libgudev
, libwacom
, xwayland
, meson
, gnome-settings-daemon
, xorgserver
, python3
, wrapGAppsHook
, sysprof
, desktop-file-utils
, libcap_ng
, egl-wayland
, graphene
, wayland-protocols
}:

let self = stdenv.mkDerivation rec {
  pname = "mutter";
  version = "3.38.2";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "03a612m0c7v6y72bs3ghmpyk49177fzq6gdy1jrz4608vnalx5yr";
  };

  patches = [
    # Drop inheritable cap_sys_nice, to prevent the ambient set from leaking
    # from mutter/gnome-shell, see https://github.com/NixOS/nixpkgs/issues/71381
    ./drop-inheritable.patch

    (substituteAll {
      src = ./fix-paths.patch;
      inherit zenity;
    })
  ];

  mesonFlags = [
    "-Degl_device=true"
    "-Dinstalled_tests=false" # TODO: enable these
    "-Dwayland_eglstream=true"
    "-Dprofiler=true"
    "-Dxwayland_path=${xwayland}/bin/Xwayland"
    # This should be auto detected, but it looks like it manages a false
    # positive.
    "-Dxwayland_initfd=disabled"
  ];

  propagatedBuildInputs = [
    # required for pkg-config to detect mutter-clutter
    json-glib
    libXtst
    libcap_ng
    graphene
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
    xorgserver # for cvt command
  ];

  buildInputs = [
    cairo
    egl-wayland
    glib
    gnome-desktop
    gnome-settings-daemon
    gobject-introspection
    gsettings-desktop-schemas
    gtk3
    libcanberra
    libgudev
    libinput
    libstartup_notification
    libwacom
    libxkbcommon
    libxkbfile
    pango
    pipewire
    sysprof
    xkeyboard_config
    xwayland
    wayland-protocols
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  # Install udev files into our own tree.
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  passthru = {
    libdir = "${self}/lib/mutter-7";

    tests = {
      libdirExists = runCommand "mutter-libdir-exists" {} ''
        if [[ ! -d ${self.libdir} ]]; then
          echo "passthru.libdir should contain a directory, “${self.libdir}” is not one."
          exit 1
        fi
        touch $out
      '';
    };

    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with lib; {
    description = "A window manager for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/mutter";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
};
in self
