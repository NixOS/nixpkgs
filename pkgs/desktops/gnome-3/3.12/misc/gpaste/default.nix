{ stdenv, fetchurl, intltool, autoreconfHook, pkgconfig, vala, glib
, pango, gtk3, gnome3, dbus, clutter, appdata-tools, makeWrapper }:

stdenv.mkDerivation rec {
  version = "3.12.2";
  name = "gpaste-${version}";

  src = fetchurl {
    url = "https://github.com/Keruspe/GPaste/archive/v${version}.tar.gz";
    sha256 = "665c1d228c02148a8a1a5675d352cd4397a02c0c9992af2e9f0258dcc6b812ec";
  };

  buildInputs = [ intltool autoreconfHook pkgconfig vala glib
                  gtk3 gnome3.gnome_control_center dbus.libs
                  clutter pango appdata-tools makeWrapper ];

  preConfigure = "intltoolize -f";

  configureFlags = [ "--with-controlcenterdir=$(out)/gnome-control-center/keybindings"
                     "--with-dbusservicesdir=$(out)/share/dbus-1/services" ];

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
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
          --prefix LD_LIBRARY_PATH : "${libPath}"
      done
    '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Keruspe/GPaste;
    description = "Clipboard management system with GNOME3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
