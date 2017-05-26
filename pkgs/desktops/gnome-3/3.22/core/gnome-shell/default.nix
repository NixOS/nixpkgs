{ fetchurl, stdenv, pkgconfig, gnome3, json_glib, libcroco, intltool, libsecret
, python3Packages, libsoup, polkit, clutter, networkmanager, docbook_xsl , docbook_xsl_ns, at_spi2_core
, libstartup_notification, telepathy_glib, telepathy_logger, libXtst, p11_kit, unzip
, sqlite, libgweather, libcanberra_gtk3
, libpulseaudio, libical, libtool, nss, gobjectIntrospection, gstreamer, makeWrapper
, accountsservice, gdk_pixbuf, gdm, upower, ibus, networkmanagerapplet, librsvg }:

# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/gnome-base/gnome-shell/gnome-shell-3.10.2.1.ebuild?revision=1.3&view=markup

let
  pythonEnv = python3Packages.python.withPackages ( ps: with ps; [ pygobject3 ] );
in stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # Needed to find /etc/NetworkManager/VPN
  configureFlags = [ "--sysconfdir=/etc" ];

  buildInputs = with gnome3;
    [ gsettings_desktop_schemas gnome_keyring gnome-menus glib gcr json_glib accountsservice
      libcroco intltool libsecret pkgconfig libsoup polkit libcanberra_gtk2 gdk_pixbuf librsvg
      clutter networkmanager libstartup_notification telepathy_glib docbook_xsl docbook_xsl_ns
      libXtst p11_kit networkmanagerapplet gjs mutter libpulseaudio caribou evolution_data_server
      libical libtool nss gtk gstreamer makeWrapper gdm
      libcanberra_gtk3 gnome_control_center
      defaultIconTheme sqlite gnome3.gnome-bluetooth
      libgweather # not declared at build time, but typelib is needed at runtime
      gnome3.gnome-clocks # schemas needed
      at_spi2_core upower ibus gnome_desktop telepathy_logger gnome3.gnome_settings_daemon
      pythonEnv gobjectIntrospection dconf ];

  installFlags = [ "keysdir=$(out)/share/gnome-control-center/keybindings" ];

  preBuild = ''
    patchShebangs src/data-to-c.pl
    substituteInPlace data/Makefile --replace " install-keysDATA" ""
  '';

  preFixup = with gnome3; ''
    wrapProgram "$out/bin/gnome-shell" \
      --prefix PATH : "${unzip}/bin" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS" \
      --suffix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

    wrapProgram "$out/libexec/gnome-shell-calendar-server" \
      --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${evolution_data_server}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"

    echo "${unzip}/bin" > $out/${passthru.mozillaPlugin}/extra-bin-path
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
