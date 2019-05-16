{ fetchurl, fetchpatch, substituteAll, stdenv, meson, ninja, pkgconfig, gnome3, json-glib, libcroco, gettext, libsecret
, python3, libsoup, polkit, clutter, networkmanager, docbook_xsl , docbook_xsl_ns, at-spi2-core
, libstartup_notification, telepathy-glib, telepathy-logger, libXtst, unzip, glibcLocales, shared-mime-info
, libgweather, libcanberra-gtk3, librsvg, geoclue2, perl, docbook_xml_dtd_42, desktop-file-utils
, libpulseaudio, libical, gobject-introspection, gstreamer, wrapGAppsHook, libxslt, gcr, caribou
, accountsservice, gdk_pixbuf, gdm, upower, ibus, networkmanagerapplet, libgnomekbd, gnome-desktop
, gsettings-desktop-schemas, gnome-keyring, glib, gjs, mutter, evolution-data-server, gtk3
, sassc, systemd, gst_all_1, adwaita-icon-theme, gnome-bluetooth, gnome-clocks, gnome-settings-daemon }:

# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/gnome-base/gnome-shell/gnome-shell-3.10.2.1.ebuild?revision=1.3&view=markup

let
  pythonEnv = python3.withPackages ( ps: with ps; [ pygobject3 ] );

in stdenv.mkDerivation rec {
  name = "gnome-shell-${version}";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1pb00af3w4wivdhcvdy59z2xlxasg90bcm5a9ck0p5lf97adwx08";
  };

  LANG = "en_US.UTF-8";

  nativeBuildInputs = [
    meson ninja pkgconfig gettext docbook_xsl docbook_xsl_ns docbook_xml_dtd_42 perl wrapGAppsHook glibcLocales
    sassc desktop-file-utils libxslt.bin python3
  ];
  buildInputs = [
    systemd caribou
    gsettings-desktop-schemas gnome-keyring glib gcr json-glib accountsservice
    libcroco libsecret libsoup polkit gdk_pixbuf librsvg
    clutter networkmanager libstartup_notification telepathy-glib
    libXtst gjs mutter libpulseaudio evolution-data-server
    libical gtk3 gstreamer gdm libcanberra-gtk3 geoclue2
    adwaita-icon-theme gnome-bluetooth
    gnome-clocks # schemas needed
    at-spi2-core upower ibus gnome-desktop telepathy-logger gnome-settings-daemon
    gst_all_1.gst-plugins-good # recording
    gobject-introspection

    # not declared at build time, but typelib is needed at runtime
    libgweather networkmanagerapplet
  ];
  propagatedUserEnvPkgs = [
    # Needed to support on-screen keyboard used with touch screen devices
    # see https://github.com/NixOS/nixpkgs/issues/25968
    caribou
  ];

  patches = [
    (fetchpatch {
      name = "0001-build-Add-missing-dependency-to-run-js-test.patch";
      url = https://bug787864.bugzilla-attachments.gnome.org/attachment.cgi?id=360016;
      sha256 = "1dmahd8ysbzh33rxglba0fbq127aw9h14cl2a2bw9913vjxhxijm";
    })
    (substituteAll {
      src = ./fix-paths.patch;
      inherit libgnomekbd unzip;
    })
  ];

  postPatch = ''
    patchShebangs src/data-to-c.pl

    substituteInPlace src/gnome-shell-extension-tool.in --replace "@PYTHON@" "${pythonEnv}/bin/python"
    substituteInPlace src/gnome-shell-perf-tool.in --replace "@PYTHON@" "${pythonEnv}/bin/python"
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Until glib’s xdgmime is patched
      # Fixes “Failed to load resource:///org/gnome/shell/theme/noise-texture.png: Unrecognized image file format”
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
    updateScript = gnome3.updateScript {
      packageName = "gnome-shell";
      attrPath = "gnome3.gnome-shell";
    };
  };

  meta = with stdenv.lib; {
    description = "Core user interface for the GNOME 3 desktop";
    homepage = https://wiki.gnome.org/Projects/GnomeShell;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };

}
