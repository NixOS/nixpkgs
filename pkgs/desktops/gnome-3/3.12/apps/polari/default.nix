{stdenv, fetchurl, makeWrapper, intltool, pkgconfig, gobjectIntrospection, glib, gtk3, telepathy_glib, gnome3, telepathy_idle }:

stdenv.mkDerivation rec {
  version = "3.12.2";
  name = "polari-${version}";
  src = fetchurl {
    url = "https://download.gnome.org/sources/polari/3.12/polari-${version}.tar.xz";
    sha256 = "8b10f369fac9e5e48a7bed51320754262d00c1bb14899a321b02843e20c0a995";
  };
  buildInputs = [ makeWrapper intltool pkgconfig gobjectIntrospection glib gtk3 telepathy_glib gnome3.gjs ];
  propagatedUserEnvPkgs = [ telepathy_idle ];

  preFixup = ''
    wrapProgram "$out/bin/polari" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" 
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Internet Relay Chat (IRC) client designed for GNOME 3";
    homepage = https://wiki.gnome.org/Apps/Polari;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
