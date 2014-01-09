{ fetchurl, stdenv, intltool, pkgconfig, itstool, libxml2, libjpeg, gnome3
, shared_mime_info, makeWrapper, librsvg, libexif }:


stdenv.mkDerivation rec {
  name = "eog-3.11.2";

  src = fetchurl {
    url = "mirror://gnome/sources/eog/3.11/${name}.tar.xz";
    sha256 = "0arad1jzp7hwwxq1s1913j07z8flvdkvvwcbvsrjls3gp5s6lgsw";
  };

  buildInputs = with gnome3;
    [ intltool pkgconfig itstool libxml2 libjpeg gtk glib libpeas makeWrapper librsvg
      gsettings_desktop_schemas shared_mime_info gnome_icon_theme gnome_desktop libexif ];

  postInstall = ''
    wrapProgram "$out/bin/eog" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "${shared_mime_info}/share:${gnome3.gnome_icon_theme}/share:${gnome3.gsettings_desktop_schemas}/share:$out/share"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/EyeOfGnome; 
    platforms = platforms.linux;
    description = "GNOME image viewer";
  };
}
