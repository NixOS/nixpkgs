{ stdenv, intltool, fetchurl, pkgconfig, gtk3
, glib, desktop_file_utils, bash
, makeWrapper, gnome3, file, itstool, libxml2 }:

# TODO: icons and theme still does not work
# use packaged gnome3.gnome_icon_theme_symbolic 

stdenv.mkDerivation rec {
  name = "gucharmap-3.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gucharmap/3.12/${name}.tar.xz";
    sha256 = "5e260767da43f6dc31a8be33ca363da56781349b367464fa9c478bca66aa18d9";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  buildInputs = [ pkgconfig gtk3 intltool itstool glib
                  gnome3.yelp_tools libxml2 file desktop_file_utils
                  gnome3.gsettings_desktop_schemas makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/gucharmap" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gucharmap;
    description = "GNOME Character Map, based on the Unicode Character Database";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
