{ stdenv
, lib
, fetchpatch
, substituteAll
, fetchurl
, meson
, ninja
, pkg-config
, gnome
, perl
, gettext
, gtk3
, glib
, libnotify
, libgnomekbd
, lcms2
, libpulseaudio
, alsa-lib
, libcanberra-gtk3
, upower
, colord
, libgweather
, polkit
, gsettings-desktop-schemas
, geoclue2
, systemd
, libgudev
, libwacom
, libxslt
, libxml2
, modemmanager
, networkmanager
, gnome-desktop
, geocode-glib_2
, docbook_xsl
, wrapGAppsHook
, python3
, tzdata
, nss
, gcr
, gnome-session-ctl
, pantheon
}:

stdenv.mkDerivation rec {
  pname = "gnome-settings-daemon";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "136p3prdqvc0lvrcqs4h7crpnfqnimqklpzjivq5w4g1rhbdbhrj";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/merge_requests/202
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/commit/aae1e774dd9de22fe3520cf9eb2bfbf7216f5eb0.patch";
      sha256 = "O4m0rOW8Zrgu3Q0p0OA8b951VC0FjYbOUk9MLzB9icI=";
    })

    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata;
    })

    # Adjust to libgweather changes.
    # https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/merge_requests/217
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/commit/82d88014dfca2df7e081712870e1fb017c16b808.patch";
      sha256 = "H5k/v+M2bRaswt5nrDJFNn4gS4BdB0UfzdjUCT4yLKg=";
    })

    # Fix build with new meson
    # plugins/power/meson.build:78:7: ERROR: Function does not take positional arguments.
    # https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/merge_requests/283
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/commit/afa7e4bb9c519e2daf500a6079088669500768c0.patch";
      sha256 = "8wxJIKPoZyfs1t0zAsb5SVCdt297NUiGmXIBNI6hbCQ=";
    })
    # meson.build:86:3: ERROR: The `==` operator of str does not accept objects of type bool (True)
    # https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/merge_requests/249
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/commit/28e28e9e598342c897ae5ca350d0da6f4aea057b.diff";
      sha256 = "U+suR7wYjLWPqmkJpHm6pPOWL7sjL6GhIFX8MHrBRAY=";
    })

    # Port to gweather4
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/commit/66cae69ad82cfc59435016fba737ce046ffb7e66.patch";
      sha256 = "zf8/rkKdQQFNV/qx/jo4kx1KoLl7SUSu4/T1OBGrZ4c=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/commit/f390e6e9d56ce7d3e3a725b8204d81c0b6240515.patch";
      sha256 = "8mfnlhkSF9ogjVWE+IESzRQzrxHQSwUWsq5OLBM08iM=";
    })

    # Use geocode-glib_2 dependency
    # https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/merge_requests/300
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/commit/03739474621e579e10b72577960ff94b4001e7ff.patch";
      sha256 = "W4uD4ChNPZSsmQfmfmmXFA2Sm1RDkV7MqG8DmT4qeCY=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    perl
    gettext
    libxml2
    libxslt
    docbook_xsl
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk3
    glib
    gsettings-desktop-schemas
    modemmanager
    networkmanager
    libnotify
    libgnomekbd # for org.gnome.libgnomekbd.keyboard schema
    gnome-desktop
    lcms2
    libpulseaudio
    alsa-lib
    libcanberra-gtk3
    upower
    colord
    libgweather
    nss
    polkit
    geocode-glib_2
    geoclue2
    systemd
    libgudev
    libwacom
    gcr
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
    "-Dgnome_session_ctl_path=${gnome-session-ctl}/libexec/gnome-session-ctl"
  ];

  # Default for release buildtype but passed manually because
  # we're using plain
  NIX_CFLAGS_COMPILE = "-DG_DISABLE_CAST_CHECKS";

  postPatch = ''
    for f in gnome-settings-daemon/codegen.py plugins/power/gsd-power-constants-update.pl meson_post_install.py; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  meta = with lib; {
    description = "GNOME Settings Daemon";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-settings-daemon/";
    license = licenses.gpl2Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
  };
}
