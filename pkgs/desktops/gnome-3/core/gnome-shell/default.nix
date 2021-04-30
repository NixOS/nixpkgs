{ fetchurl
, fetchpatch
, substituteAll
, lib, stdenv
, meson
, ninja
, pkg-config
, gnome3
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
, docbook_xml_dtd_42
, docbook_xml_dtd_43
, desktop-file-utils
, libpulseaudio
, libical
, gobject-introspection
, wrapGAppsHook
, libxslt
, gcr
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
, sassc
, systemd
, pipewire
, gst_all_1
, adwaita-icon-theme
, gnome-bluetooth
, gnome-clocks
, gnome-settings-daemon
, gnome-autoar
, asciidoc-full
, bash-completion
, mesa
}:

# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/gnome-base/gnome-shell/gnome-shell-3.10.2.1.ebuild?revision=1.3&view=markup
let
  pythonEnv = python3.withPackages (ps: with ps; [ pygobject3 ]);
in
stdenv.mkDerivation rec {
  pname = "gnome-shell";
  version = "3.38.3";

  outputs = [ "out" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-U0W0GMsSqXKVXOXM6u1mYkgAJzNrXFHa6lcwV1tiHO0=";
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
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    docbook-xsl-nons
    # Switch to 4.5 in the 40.
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    gtk-doc
    perl
    wrapGAppsHook
    sassc
    desktop-file-utils
    libxslt.bin
    python3
    asciidoc-full
  ];

  buildInputs = [
    systemd
    gsettings-desktop-schemas
    gnome-keyring
    glib
    gcr
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
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    patchShebangs src/data-to-c.pl
    chmod +x meson/postinstall.py
    patchShebangs meson/postinstall.py

    substituteInPlace src/gnome-shell-extension-tool.in --replace "@PYTHON@" "${pythonEnv}/bin/python"
    substituteInPlace src/gnome-shell-perf-tool.in --replace "@PYTHON@" "${pythonEnv}/bin/python"
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
    for svc in org.gnome.Shell.Extensions org.gnome.Shell.Notifications org.gnome.Shell.Screencast; do
      wrapGApp $out/share/gnome-shell/$svc
    done
  '';

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
    updateScript = gnome3.updateScript {
      packageName = "gnome-shell";
      attrPath = "gnome3.gnome-shell";
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
