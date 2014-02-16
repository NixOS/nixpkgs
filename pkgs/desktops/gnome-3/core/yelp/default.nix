{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib, file
, bash, makeWrapper, itstool, libxml2, libxslt, gnome3, icu }:

# TODO: icons and theme still does not work
# use packaged gnome3.gnome_icon_theme_symbolic 

stdenv.mkDerivation rec {
  name = "yelp-3.10.1";

  src = fetchurl {
    url = "https://download.gnome.org/sources/yelp/3.10/${name}.tar.xz";
    sha256 = "17736479b7d0b1128c7d6cb3073f2b09e4bbc82670731b2a0d3a3219a520f816";
  };

  configureFlags = [ "--disable-static" ];

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  buildInputs = [ pkgconfig gtk3 glib webkitgtk intltool itstool libxml2 libxslt icu file
                  gnome3.gsettings_desktop_schemas makeWrapper gnome3.yelp_xsl ];

  installFlags = "gsettingsschemadir=\${out}/share/${name}/glib-2.0/schemas/";

  postInstall = ''
    wrapProgram "$out/bin/yelp" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:${gnome3.gsettings_desktop_schemas}/share:$out/share:$out/share/${name}"
  '';

  preFixup = ''
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Yelp;
    description = "Yelp is the help viewer in Gnome.";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
