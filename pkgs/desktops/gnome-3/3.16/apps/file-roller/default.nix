{ stdenv, fetchurl, glib, pkgconfig, gnome3, intltool, itstool, libxml2, libarchive
, attr, bzip2, acl, makeWrapper, librsvg, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "file-roller-${version}";

  majVersion = gnome3.version;
  version = "${majVersion}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${majVersion}/${name}.tar.xz";
    sha256 = "12c6lpvc3mi1q10nas64kfcjw2arv3z4955zdfgf4c5wy4dczqyh";
  };

  # TODO: support nautilus
  # it tries to create {nautilus}/lib/nautilus/extensions-3.0/libnautilus-fileroller.so

  buildInputs = [ glib pkgconfig gnome3.gtk intltool itstool libxml2 libarchive
                  gnome3.defaultIconTheme attr bzip2 acl gdk_pixbuf librsvg
                  makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/file-roller" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/FileRoller;
    description = "Archive manager for the GNOME desktop environment";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
