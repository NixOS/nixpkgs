{ stdenv, intltool, fetchurl, pkgconfig, gtk3
, glib, desktop_file_utils, bash
, makeWrapper, gnome3, file, itstool, libxml2 }:

# TODO: icons and theme still does not work
# use packaged gnome3.gnome_icon_theme_symbolic 

stdenv.mkDerivation rec {
  name = "gucharmap-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gucharmap/3.10/${name}.tar.xz";
    sha256 = "04e8606c65adb14d267b50b1cf9eb4fee92bd9c5ab512a346bd4c9c686403f78";
  };

  configureFlags = [ "--disable-static" ];

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  buildInputs = [ pkgconfig gtk3 intltool itstool glib
                  gnome3.yelp_tools libxml2 file desktop_file_utils
                  gnome3.gsettings_desktop_schemas makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/gucharmap" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gucharmap;
    description = "GNOME Character Map, based on the Unicode Character Database";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
