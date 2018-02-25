{ fetchurl, fetchpatch, stdenv, meson, ninja, pkgconfig, gnome3, json-glib, libcroco, gettext, libsecret
, python3Packages, libsoup, polkit, clutter, networkmanager, docbook_xsl , docbook_xsl_ns, at-spi2-core
, libstartup_notification, telepathy-glib, telepathy-logger, libXtst, p11-kit, unzip, glibcLocales
, sqlite, libgweather, libcanberra-gtk3, librsvg, geoclue2, perl, docbook_xml_dtd_42
, libpulseaudio, libical, nss, gobjectIntrospection, gstreamer, wrapGAppsHook
, accountsservice, gdk_pixbuf, gdm, upower, ibus, networkmanagerapplet
, gst_all_1 }:

# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/gnome-base/gnome-shell/gnome-shell-3.10.2.1.ebuild?revision=1.3&view=markup

let
  pythonEnv = python3Packages.python.withPackages ( ps: with ps; [ pygobject3 ] );

in stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # Needed to find /etc/NetworkManager/VPN
  mesonFlags = [ "--sysconfdir=/etc" ];

  LANG = "en_US.UTF-8";

  nativeBuildInputs = [ meson ninja gettext docbook_xsl docbook_xsl_ns docbook_xml_dtd_42 perl wrapGAppsHook glibcLocales ];
  buildInputs = with gnome3;
    [ gsettings-desktop-schemas gnome-keyring gnome-menus glib gcr json-glib accountsservice
      libcroco libsecret pkgconfig libsoup polkit gdk_pixbuf
      (librsvg.override { enableIntrospection = true; })
      clutter networkmanager libstartup_notification telepathy-glib
      libXtst p11-kit networkmanagerapplet gjs mutter libpulseaudio caribou evolution-data-server
      libical nss gtk gstreamer gdm
      libcanberra-gtk3 gnome-control-center geoclue2
      defaultIconTheme sqlite gnome3.gnome-bluetooth
      libgweather # not declared at build time, but typelib is needed at runtime
      gnome3.gnome-clocks # schemas needed
      at-spi2-core upower ibus gnome-desktop telepathy-logger gnome3.gnome-settings-daemon
      gst_all_1.gst-plugins-good # recording
      gobjectIntrospection (stdenv.lib.getLib dconf) ];
  propagatedUserEnvPkgs = [
    # Needed to support on-screen keyboard used with touch screen devices
    # see https://github.com/NixOS/nixpkgs/issues/25968
    gnome3.caribou
  ];

  patches = [
    (fetchpatch {
      name = "0001-build-Add-missing-dependency-to-run-js-test.patch";
      url = https://bug787864.bugzilla-attachments.gnome.org/attachment.cgi?id=360016;
      sha256 = "1dmahd8ysbzh33rxglba0fbq127aw9h14cl2a2bw9913vjxhxijm";
    })
    ./fix-paths.patch
  ];

  postPatch = ''
    patchShebangs src/data-to-c.pl

    substituteInPlace src/gnome-shell-extension-tool.in --replace "@PYTHON@" "${pythonEnv}/bin/python"
    substituteInPlace src/gnome-shell-perf-tool.in --replace "@PYTHON@" "${pythonEnv}/bin/python"
    substituteInPlace js/ui/extensionDownloader.js --replace "unzip" "${unzip}/bin/unzip"
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  postFixup = ''
    # Patched meson does not add internal libraries to rpath
    patchelf --set-rpath "$out/lib/gnome-shell:$(patchelf --print-rpath $out/bin/.gnome-shell-wrapped)" $out/bin/.gnome-shell-wrapped
  '';

  enableParallelBuilding = true;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
