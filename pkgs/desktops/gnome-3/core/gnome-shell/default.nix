{ fetchurl, fetchpatch, substituteAll, stdenv, meson, ninja, pkgconfig, gnome3, json-glib, gettext, libsecret
, python3, libsoup, polkit, clutter, networkmanager, docbook_xsl , docbook_xsl_ns, at-spi2-core
, libstartup_notification, telepathy-glib, telepathy-logger, libXtst, unzip, glibcLocales, shared-mime-info
, libgweather, libcanberra-gtk3, librsvg, geoclue2, perl, docbook_xml_dtd_42, desktop-file-utils
, libpulseaudio, libical, gobject-introspection, wrapGAppsHook, libxslt, gcr
, accountsservice, gdk-pixbuf, gdm, upower, ibus, libnma, libgnomekbd, gnome-desktop
, gsettings-desktop-schemas, gnome-keyring, glib, gjs, mutter, evolution-data-server, gtk3
, sassc, systemd, gst_all_1, adwaita-icon-theme, gnome-bluetooth, gnome-clocks, gnome-settings-daemon
, gnome-autoar, asciidoc-full
, bash-completion
}:

# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/gnome-base/gnome-shell/gnome-shell-3.10.2.1.ebuild?revision=1.3&view=markup

let
  pythonEnv = python3.withPackages ( ps: with ps; [ pygobject3 ] );

in stdenv.mkDerivation rec {
  pname = "gnome-shell";
  version = "3.36.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1fs51lcaal4lnx6m5a3j8922yjbjk32khznx77cxb2db1zvspn46";
  };

  LANG = "en_US.UTF-8";

  nativeBuildInputs = [
    meson ninja pkgconfig gettext docbook_xsl docbook_xsl_ns docbook_xml_dtd_42 perl wrapGAppsHook glibcLocales
    sassc desktop-file-utils libxslt.bin python3 asciidoc-full
  ];
  buildInputs = [
    systemd
    gsettings-desktop-schemas gnome-keyring glib gcr json-glib accountsservice
    libsecret libsoup polkit gdk-pixbuf librsvg
    networkmanager libstartup_notification telepathy-glib
    libXtst gjs mutter libpulseaudio evolution-data-server
    libical gtk3 gdm libcanberra-gtk3 geoclue2
    adwaita-icon-theme gnome-bluetooth
    gnome-clocks # schemas needed
    at-spi2-core upower ibus gnome-desktop telepathy-logger gnome-settings-daemon
    gobject-introspection
    gnome-autoar

    # recording
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good

    # not declared at build time, but typelib is needed at runtime
    libgweather libnma

    # for gnome-extension tool
    bash-completion
  ];

  patches = [
    # Hardcode paths to various dependencies so that they can be found at runtime.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit libgnomekbd unzip;
      gsettings = "${glib.bin}/bin/gsettings";
    })

    # Install bash-completions to correct prefix.
    # https://gitlab.gnome.org/GNOME/gnome-shell/merge_requests/1194
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-shell/commit/9f1ad5d86ddbabaa840eb2860279d53f4e635453.patch";
      sha256 = "18amnqw342vllcrjpfcq232z9xr28vgjsf2z8k73xx70nwah7hvz";
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
    for svc in org.gnome.Shell.Extensions org.gnome.Shell.Notifications; do
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

  meta = with stdenv.lib; {
    description = "Core user interface for the GNOME 3 desktop";
    homepage = "https://wiki.gnome.org/Projects/GnomeShell";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };

}
