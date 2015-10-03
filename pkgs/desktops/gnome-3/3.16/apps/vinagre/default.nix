{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, vte, libxml2, gtkvnc, intltool
, libsecret, itstool, makeWrapper, librsvg }:

stdenv.mkDerivation rec {
  name = "vinagre-${version}";

  majVersion = gnome3.version;
  version = "${majVersion}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/vinagre/${majVersion}/${name}.tar.xz";
    sha256 = "0gs8sqd4r6jlgxn1b7ggyfcisig50z79p0rmigpzwpjjx1bh0z6p";
  };

  buildInputs = [ pkgconfig gtk3 vte libxml2 gtkvnc intltool libsecret
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
