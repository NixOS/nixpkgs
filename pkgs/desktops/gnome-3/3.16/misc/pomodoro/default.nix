{ stdenv, fetchFromGitHub, which, automake113x, intltool, pkgconfig, libtool, makeWrapper,
  dbus_glib, libcanberra, gst_all_1, vala, gnome3, gtk3, gst_plugins_base,
  glib, gobjectIntrospection, telepathy_glib
}:

stdenv.mkDerivation rec {
  rev = "624945d";
  name = "gnome-shell-pomodoro-${gnome3.version}-${rev}";

  src = fetchFromGitHub {
      owner = "codito";
      repo = "gnome-pomodoro";
      rev = "${rev}";
      sha256 = "0vjy95zvd309n8g13fa80qhqlv7k6wswhrjw7gddxrnmr662xdqq";
  };

  configureScript = ''./autogen.sh'';

  buildInputs = [
    which automake113x intltool glib gobjectIntrospection pkgconfig libtool
    makeWrapper dbus_glib libcanberra vala gst_all_1.gstreamer
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gnome3.gsettings_desktop_schemas gnome3.gnome_desktop
    gnome3.gnome_common gnome3.gnome_shell gtk3 telepathy_glib
    gnome3.defaultIconTheme
  ];

  preBuild = ''
    sed -i 's|\$(INTROSPECTION_GIRDIR)|${gnome3.gnome_desktop}/share/gir-1.0|' \
      vapi/Makefile
  '';

  preFixup = ''
    wrapProgram $out/bin/gnome-pomodoro \
        --prefix XDG_DATA_DIRS : \
        "$out/share:$GSETTINGS_SCHEMAS_PATH:$XDG_DATA_DIRS"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/codito/gnome-shell-pomodoro;
    description = "A time management utility for GNOME based on the pomodoro technique";
    longDescription = ''
      This GNOME utility helps to manage time according to Pomodoro Technique.
      It intends to improve productivity and focus by taking short breaks.
    '';
    maintainers = with maintainers; [ DamienCassou jgeerds ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
