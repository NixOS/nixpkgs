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
, wrapGAppsHook3
, python3
, tzdata
, nss
, gcr_4
, gnome-session-ctl
}:

stdenv.mkDerivation rec {
  pname = "gnome-settings-daemon";
  version = "43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "NRO7JPxvgYFmciOmSgZ1NP3M879mMmqUA9OLDw1gE9A=";
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
    wrapGAppsHook3
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
    gcr_4
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
    "-Dgnome_session_ctl_path=${gnome-session-ctl}/libexec/gnome-session-ctl"
  ];

  # Default for release buildtype but passed manually because
  # we're using plain
  env.NIX_CFLAGS_COMPILE = "-DG_DISABLE_CAST_CHECKS";

  postPatch = ''
    for f in gnome-settings-daemon/codegen.py plugins/power/gsd-power-constants-update.pl; do
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
