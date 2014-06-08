{ stdenv, fetchurl, glib, pkgconfig, gnome3, intltool, itstool, libxml2, libarchive
, attr, bzip2, acl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "file-roller-${version}";

  majVersion = "3.12";
  version = "${majVersion}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${majVersion}/${name}.tar.xz";
    sha256 = "0677be6618dba609eae2d76420e8a5a8d9a414bcec654e7b71e65b941764eacf";
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
