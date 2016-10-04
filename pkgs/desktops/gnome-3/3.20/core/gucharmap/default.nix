{ stdenv, intltool, fetchurl, pkgconfig, gtk3
, glib, desktop_file_utils, bash, appdata-tools
, makeWrapper, gnome3, file, itstool, libxml2 }:

# TODO: icons and theme still does not work
# use packaged gnome3.adwaita-icon-theme 

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  buildInputs = [ pkgconfig gtk3 intltool itstool glib appdata-tools
                  gnome3.yelp_tools libxml2 file desktop_file_utils
                  gnome3.gsettings_desktop_schemas makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/gucharmap" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gucharmap;
    description = "GNOME Character Map, based on the Unicode Character Database";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
