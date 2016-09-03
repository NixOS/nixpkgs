{ stdenv, fetchurl, intltool, autoreconfHook, pkgconfig, vala_0_32, glib
, pango, gtk3, gnome3, dbus, clutter, appstream-glib, makeWrapper, systemd, gobjectIntrospection }:

stdenv.mkDerivation rec {
  version = "${gnome3.version}.4";
  name = "gpaste-${version}";

  src = fetchurl {
    url = "https://github.com/Keruspe/GPaste/archive/v${version}.tar.gz";
    sha256 = "08h1igdgapz7px12r7mrfcxmz68g9ijg73w69j75spg0yc6f4xax";
  };

  buildInputs = [ intltool autoreconfHook pkgconfig vala_0_32 glib
                  gtk3 gnome3.gnome_control_center dbus
                  clutter pango appstream-glib makeWrapper systemd gobjectIntrospection ];

  preConfigure = "intltoolize -f";

  configureFlags = [ "--with-controlcenterdir=$(out)/gnome-control-center/keybindings"
                     "--with-dbusservicesdir=$(out)/share/dbus-1/services"
                     "--with-systemduserunitdir=$(out)/etc/systemd/user" ];

  enableParallelBuilding = true;

  preFixup = 
    let
      libPath = stdenv.lib.makeLibraryPath
        [ glib gtk3 clutter pango ];
    in
    ''
      for i in $out/libexec/gpaste/*; do
        wrapProgram $i \
          --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
      done
    '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Keruspe/GPaste;
    description = "Clipboard management system with GNOME3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
