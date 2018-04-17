{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, vte, libxml2, gtkvnc, intltool
, libsecret, itstool, makeWrapper, librsvg }:

stdenv.mkDerivation rec {
  name = "vinagre-${version}";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/vinagre/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "cd1cdbacca25c8d1debf847455155ee798c3e67a20903df8b228d4ece5505e82";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "vinagre"; attrPath = "gnome3.vinagre"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 vte libxml2 gtkvnc intltool libsecret
                  itstool makeWrapper gnome3.defaultIconTheme librsvg ];

  preFixup = ''
    wrapProgram "$out/bin/vinagre" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Vinagre;
    description = "Remote desktop viewer for GNOME";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
