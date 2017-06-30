{ stdenv, fetchFromGitHub, which, automake113x, intltool, pkgconfig, libtool, makeWrapper,
  dbus_glib, libcanberra_gtk2, gst_all_1, vala_0_32, gnome3, gtk3, gst-plugins-base,
  glib, gobjectIntrospection, telepathy_glib
}:

stdenv.mkDerivation rec {
  version = "0.11.2";
  name = "gnome-shell-pomodoro-${version}";

  src = fetchFromGitHub {
      owner = "codito";
      repo = "gnome-pomodoro";
      rev = "${version}";
      sha256 = "0x656drq8vnvdj1x6ghnglgpa0z8yd2yj9dh5iqprwjv0z3qkw4l";
  };

  configureScript = ''./autogen.sh'';

  buildInputs = [
    which automake113x intltool glib gobjectIntrospection pkgconfig libtool
    makeWrapper dbus_glib libcanberra_gtk2 vala_0_32 gst_all_1.gstreamer
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
    maintainers = with maintainers; [ jgeerds ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
