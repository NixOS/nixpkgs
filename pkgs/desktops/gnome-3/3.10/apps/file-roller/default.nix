{ stdenv, fetchurl, glib, pkgconfig, gnome3, intltool, itstool, libxml2, libarchive
, attr, bzip2, acl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "file-roller-${version}";

  majVersion = "3.10";
  version = "${majVersion}.2.1";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${majVersion}/${name}.tar.xz";
    sha256 = "14374z1yfbjlgpl4k1ih8b35x8kzvh99y22rwwkc2wfz0d0i1qgx";
  };

  # TODO: support nautilus
  # it tries to create {nautilus}/lib/nautilus/extensions-3.0/libnautilus-fileroller.so

  buildInputs = [ glib pkgconfig gnome3.gtk intltool itstool libxml2 libarchive
                  attr bzip2 acl makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/file-roller" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
