{ stdenv
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
, mousetweaks
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
, networkmanager
, gnome-desktop
, geocode-glib
, docbook_xsl
, wrapGAppsHook
, python3
, tzdata
, nss
}:

stdenv.mkDerivation rec {
  pname = "gnome-settings-daemon";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "02d0s0g2mmqfib44r3sf0499r08p61s8l2ndsjssbam1bi7x2dks";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tzdata mousetweaks;
    })
    ./global-backlight-helper.patch
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
  ];

  mesonFlags = [
    "-Dudev_dir=${placeholder "out"}/lib/udev"
  ];

  NIX_CFLAGS_COMPILE = [
    # Default for release buildtype but passed manually because
    # we're using plain
    "-DG_DISABLE_CAST_CHECKS"
  ];

  # So the polkit policy can reference /run/current-system/sw/bin/gnome-settings-daemon/gsd-backlight-helper
  postFixup = ''
    mkdir -p $out/bin/gnome-settings-daemon
    ln -s $out/libexec/gsd-backlight-helper $out/bin/gnome-settings-daemon/gsd-backlight-helper
  '';

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
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
