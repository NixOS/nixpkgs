{ fetchurl
, fetchpatch
, substituteAll
, lib, stdenv
, meson
, ninja
, pkg-config
, gnome
, json-glib
, gettext
, libsecret
, python3
, polkit
, networkmanager
, gtk-doc
, docbook-xsl-nons
, at-spi2-core
, libstartup_notification
, unzip
, shared-mime-info
, libgweather
, librsvg
, geoclue2
, perl
, docbook_xml_dtd_45
, desktop-file-utils
, libpulseaudio
, libical
, gobject-introspection
, wrapGAppsHook
, libxslt
, gcr_4
, accountsservice
, gdk-pixbuf
, gdm
, upower
, ibus
, libnma
, libgnomekbd
, gnome-desktop
, gsettings-desktop-schemas
, gnome-keyring
, glib
, gjs
, mutter
, evolution-data-server
, gtk3
, gtk4
, libadwaita
, sassc
, systemd
, pipewire
, gst_all_1
, adwaita-icon-theme
, gnome-bluetooth
, gnome-clocks
, gnome-settings-daemon
, gnome-autoar
, asciidoc
, bash-completion
, mesa
}:

# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/gnome-base/gnome-shell/gnome-shell-3.10.2.1.ebuild?revision=1.3&view=markup
let
  pythonEnv = python3.withPackages (ps: with ps; [ pygobject3 ]);
in
stdenv.mkDerivation rec {
  pname = "gnome-shell";
  version = "43.beta";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "4Ri5bdn1sL0UVOSneXgPPVfONUD6vqmhaBonrpzelME=";
  };

  patches = [
    # Hardcode paths to various dependencies so that they can be found at runtime.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit libgnomekbd unzip;
      gsettings = "${glib.bin}/bin/gsettings";
    })

    # Use absolute path for libshew installation to make our patched gobject-introspection
    # aware of the location to hardcode in the generated GIR file.
    ./shew-gir-path.patch

    # Make D-Bus services wrappable.
    ./wrap-services.patch

    # Fix greeter logo being too big.
    # https://gitlab.gnome.org/GNOME/gnome-shell/issues/2591
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-shell/commit/ffb8bd5fa7704ce70ce7d053e03549dd15dce5ae.patch";
      revert = true;
      sha256 = "14h7ahlxgly0n3sskzq9dhxzbyb04fn80pv74vz1526396676dzl";
    })

    # Work around failing fingerprint auth
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gnome-shell/raw/9a647c460b651aaec0b8a21f046cc289c1999416/f/0001-gdm-Work-around-failing-fingerprint-auth.patch";
      sha256 = "pFvZli3TilUt6YwdZztpB8Xq7O60XfuWUuPMMVSpqLw=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    docbook-xsl-nons
    docbook_xml_dtd_45
    gtk-doc
    perl
    wrapGAppsHook
    sassc
    desktop-file-utils
    libxslt.bin
    asciidoc
  ];

  buildInputs = [
    systemd
    gsettings-desktop-schemas
    gnome-keyring
    glib
    gcr_4
    accountsservice
    libsecret
    polkit
    gdk-pixbuf
    librsvg
    networkmanager
    libstartup_notification
    gjs
    mutter
    libpulseaudio
    evolution-data-server
    libical
    gtk3
    gtk4
    libadwaita
    gdm
    geoclue2
    adwaita-icon-theme
    gnome-bluetooth
    gnome-clocks # schemas needed
    at-spi2-core
    upower
    ibus
    gnome-desktop
    gnome-settings-daemon
    gobject-introspection
    mesa

    # recording
    pipewire
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good

    # not declared at build time, but typelib is needed at runtime
    libgweather
    libnma

    # for gnome-extension tool
    bash-completion
    gnome-autoar
    json-glib

    # for tools
    pythonEnv
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    patchShebangs src/data-to-c.pl

    # We can generate it ourselves.
    rm -f man/gnome-shell.1
    rm data/theme/gnome-shell.css
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Until glib’s xdgmime is patched
      # Fixes “Failed to load resource:///org/gnome/shell/theme/noise-texture.png: Unrecognized image file format”
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postFixup = ''
    # The services need typelibs.
    for svc in org.gnome.ScreenSaver org.gnome.Shell.Extensions org.gnome.Shell.Notifications org.gnome.Shell.Screencast; do
      wrapGApp $out/share/gnome-shell/$svc
    done
  '';

  separateDebugInfo = true;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
    updateScript = gnome.updateScript {
      packageName = "gnome-shell";
      attrPath = "gnome.gnome-shell";
    };
  };

  meta = with lib; {
    description = "Core user interface for the GNOME 3 desktop";
    homepage = "https://wiki.gnome.org/Projects/GnomeShell";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };

}
