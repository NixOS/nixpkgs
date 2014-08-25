{ fetchurl, stdenv, pkgconfig, gnome3, json_glib, libcroco, intltool, libsecret
, python, libsoup, polkit, clutter, networkmanager, docbook_xsl, docbook_xsl_ns, at_spi2_core
, libstartup_notification, telepathy_glib, telepathy_logger, libXtst, p11_kit, unzip
, hicolor_icon_theme
, pulseaudio, libical, libtool, nss, gobjectIntrospection, gstreamer, makeWrapper
, accountsservice, gdk_pixbuf, gdm, upower, ibus, networkmanagerapplet, librsvg }:

# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/gnome-base/gnome-shell/gnome-shell-3.10.2.1.ebuild?revision=1.3&view=markup

stdenv.mkDerivation rec {
  name = "gnome-shell-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell/3.12/${name}.tar.xz";
    sha256 = "3ae230e8cb7a31e7b782c16ca178af5957858810788e26a6d630b69b3f85ce71";
  };

  buildInputs = with gnome3;
    [ gsettings_desktop_schemas gnome_keyring gnome-menus glib gcr json_glib accountsservice
      libcroco intltool libsecret pkgconfig python libsoup polkit libcanberra gdk_pixbuf librsvg
      clutter networkmanager libstartup_notification telepathy_glib docbook_xsl docbook_xsl_ns
      libXtst p11_kit networkmanagerapplet gjs mutter pulseaudio caribou evolution_data_server
      libical libtool nss gobjectIntrospection gtk gstreamer makeWrapper gdm gnome_control_center
      hicolor_icon_theme gnome_icon_theme gnome_icon_theme_symbolic
      at_spi2_core upower ibus gnome_session gnome_desktop telepathy_logger gnome3.gnome_settings_daemon ];

  installFlags = [ "keysdir=$(out)/share/gnome-control-center/keybindings" ];

  preBuild = ''
    patchShebangs src/data-to-c.pl
    substituteInPlace data/Makefile --replace " install-keysDATA" ""
  '';

  preFixup = with gnome3; ''
    wrapProgram "$out/bin/gnome-shell" \
      --prefix PATH : "${unzip}/bin" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix LD_LIBRARY_PATH : "${accountsservice}/lib:${ibus}/lib:${gdm}/lib" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"

    wrapProgram "$out/libexec/gnome-shell-calendar-server" \
      --prefix XDG_DATA_DIRS : "${evolution_data_server}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"

    echo "${unzip}/bin" > $out/${passthru.mozillaPlugin}/extra-bin-path
  '';

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
