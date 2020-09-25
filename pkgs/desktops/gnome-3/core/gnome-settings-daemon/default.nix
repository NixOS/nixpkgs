{ stdenv
, fetchFromGitLab
, substituteAll
, fetchurl
, meson
, ninja
, pkgconfig
, gnome3
, perl
, gettext
, gtk3
, glib
, libnotify
, libgnomekbd
, lcms2
, libpulseaudio
, alsaLib
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
, geocode-glib
, docbook_xsl
, wrapGAppsHook
, python3
, tzdata
, nss
, gcr
}:

stdenv.mkDerivation rec {
  pname = "gnome-settings-daemon";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0bkrsqzyrxvnw2x1p2a67k3f692ih3i5pafnxqn1kbcsmdgmpvdp";
  };

  # See https://mail.gnome.org/archives/distributor-list/2020-September/msg00001.html
  prePatch = (import ../gvc-with-ucm-prePatch.nix {
    inherit fetchFromGitLab;
  });

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
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
    alsaLib
    libcanberra-gtk3
    upower
    colord
    libgweather
    nss
    polkit
    geocode-glib
    geoclue2
    systemd
    libgudev
    libwacom
    gcr
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
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

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
