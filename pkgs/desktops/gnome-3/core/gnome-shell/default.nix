{ fetchurl, fetchpatch, substituteAll, stdenv, meson, ninja, pkgconfig, gnome3, json-glib, gettext, libsecret
, python3, libsoup, polkit, clutter, networkmanager, docbook_xsl , docbook_xsl_ns, at-spi2-core
, libstartup_notification, telepathy-glib, telepathy-logger, libXtst, unzip, glibcLocales, shared-mime-info
, libgweather, libcanberra-gtk3, librsvg, geoclue2, perl, docbook_xml_dtd_42, desktop-file-utils
, libpulseaudio, libical, gobject-introspection, wrapGAppsHook, libxslt, gcr
, accountsservice, gdk-pixbuf, gdm, upower, ibus, libnma, libgnomekbd, gnome-desktop
, gsettings-desktop-schemas, gnome-keyring, glib, gjs, mutter, evolution-data-server, gtk3
, sassc, systemd, gst_all_1, adwaita-icon-theme, gnome-bluetooth, gnome-clocks, gnome-settings-daemon
, gnome-autoar, asciidoc-full }:

# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/gnome-base/gnome-shell/gnome-shell-3.10.2.1.ebuild?revision=1.3&view=markup

let
  pythonEnv = python3.withPackages ( ps: with ps; [ pygobject3 ] );

in stdenv.mkDerivation rec {
  pname = "gnome-shell";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1phkkkwrrigchz58xs324vf6snd1fm7mxa2iaqwwj526vh5c1s2q";
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
  ];

  patches = [
    # Fix dependencies.
    # https://gitlab.gnome.org/GNOME/gnome-shell/merge_requests/1114
    (fetchpatch {
      name = "0001-build-Add-missing-dependency-to-run-js-test.patch";
      url = https://bug787864.bugzilla-attachments.gnome.org/attachment.cgi?id=360016;
      sha256 = "1dmahd8ysbzh33rxglba0fbq127aw9h14cl2a2bw9913vjxhxijm";
    })

    # Hardcode paths to various dependencies so that they can be found at runtime.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit libgnomekbd unzip;
      gsettings = "${glib.bin}/bin/gsettings";
    })

    # Fix ibus launching regression.
    # https://gitlab.gnome.org/GNOME/gnome-shell/merge_requests/1080
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-shell/commit/94f6976ddd6337593203fdcdd2e3644774408dfa.patch";
      sha256 = "PGmFQhqqd3gK+3kp0dlmlYd2G5ZTIQpfE++Q03Ghkx0=";
    })

    # Fix typing regression with ibus.
    # https://gitlab.gnome.org/GNOME/gnome-shell/merge_requests/1084
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-shell/commit/b18469427e5c19402111de5fe9888bceec0eaacd.patch";
      sha256 = "1M+3kjt7K61BFgk1Zf9XfK1ziilQGa60PD8xtVjnQec=";
    })

    # Fix theming breakage after Shell restart on X11.
    # https://gitlab.gnome.org/GNOME/gnome-shell/issues/2329
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-shell/commit/72c4f148ef88b4bffb2106b99434da5c05c0bb64.patch";
      sha256 = "RBA+JHz4ZvmbJZMnGNieD6D5LONRgFU4iOFIMQQ2kHQ=";
    })

    # Fix Telepathy chat integration.
    # https://gitlab.gnome.org/GNOME/gnome-shell/issues/2449
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-shell/commit/766288eec1bd3bd50dfc4ddf410c2b507187e603.patch";
      sha256 = "Cp6xLohCM0gmMxtyYjSukS2oV60Khmxf4iQd9EDAlIc=";
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
