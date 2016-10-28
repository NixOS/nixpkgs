{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, vte, libxml2, gtkvnc, intltool
, libsecret, itstool, makeWrapper, librsvg }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

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
