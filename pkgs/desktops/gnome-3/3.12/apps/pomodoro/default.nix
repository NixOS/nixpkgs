{ stdenv, fetchFromGitHub, which, automake113x, intltool, pkgconfig, libtool, makeWrapper,
  dbus_glib, libcanberra, gst_all_1, upower, vala, gnome3_12, gtk3, gst_plugins_base,
  glib, gobjectIntrospection, hicolor_icon_theme
}:

stdenv.mkDerivation rec {
  rev = "0.10.3";
  name = "gnome-shell-pomodoro-${rev}-61df3fa";

  src = fetchFromGitHub {
      owner = "codito";
      repo = "gnome-shell-pomodoro";
      rev = "${rev}";
      sha256 = "0i0glmijalppb5hdb1xd6xnmv824l2w831rpkqmhxi0iqbvaship";
  };

  configureScript = ''./autogen.sh'';

  buildInputs = [
    which automake113x intltool glib gobjectIntrospection pkgconfig libtool
    makeWrapper dbus_glib libcanberra upower vala gst_all_1.gstreamer
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gnome3_12.gsettings_desktop_schemas gnome3_12.gnome_desktop
    gnome3_12.gnome_common gnome3_12.gnome_shell hicolor_icon_theme gtk3
  ];

  preBuild = ''
    sed -i \
        -e 's|/usr\(/share/gir-1.0/UPowerGlib\)|${upower}\1|' \
        -e 's|/usr\(/share/gir-1.0/GnomeDesktop\)|${gnome3_12.gnome_desktop}\1|' \
        vapi/Makefile
  '';

  preFixup = ''
    wrapProgram $out/bin/gnome-pomodoro \
        --prefix XDG_DATA_DIRS : \
        "$out/share:$GSETTINGS_SCHEMAS_PATH:$XDG_DATA_DIRS"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/codito/gnome-shell-pomodoro;
    description =
      "Personal information management application that provides integrated " + 
      "mail, calendaring and address book functionality";
    maintainers = with maintainers; [ DamienCassou ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
