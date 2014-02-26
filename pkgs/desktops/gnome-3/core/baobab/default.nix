{ stdenv, intltool, fetchurl, vala, libgtop, pkgconfig, gtk3, glib
, bash, makeWrapper, itstool, libxml2, gnome3 }:

# TODO: icons and theme still does not work
# use packaged gnome3.gnome_icon_theme_symbolic 

stdenv.mkDerivation rec {
  name = "baobab-3.10.1";

  src = fetchurl {
    url = "https://download.gnome.org/sources/baobab/3.10/${name}.tar.xz";
    sha256 = "23ce8e4847ce5f1c8230e757532d94c84e6e273d6ec8fca20eecaed5f96563f9";
  };

  configureFlags = [ "--disable-static" ];

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ vala pkgconfig gtk3 glib libgtop intltool itstool libxml2
                  gnome3.gsettings_desktop_schemas makeWrapper ];

  installFlags = "gsettingsschemadir=\${out}/share/${name}/glib-2.0/schemas/";

  postInstall = ''
    wrapProgram "$out/bin/baobab" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:${gnome3.gsettings_desktop_schemas}/share:$out/share:$out/share/${name}"
  '';

  preFixup = ''
    rm $out/share/icons/hicolor/icon-theme.cache
    rm $out/share/icons/HighContrast/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Baobab;
    description = "Graphical application to analyse disk usage in any Gnome environment";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
