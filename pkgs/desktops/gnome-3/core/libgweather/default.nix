{ stdenv, fetchurl, pkgconfig, libxml2, gtk, intltool, libsoup, gconf
, pango, gdk_pixbuf, atk, tzdata, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  configureFlags = [ "--with-zoneinfo-dir=${tzdata}/share/zoneinfo" "--enable-vala" ];
  propagatedBuildInputs = [ libxml2 gtk libsoup gconf pango gdk_pixbuf atk gnome3.geocode-glib ];
  nativeBuildInputs = [ pkgconfig intltool gnome3.vala ];

  # Prevent building vapi into ${vala} derivation directory
  prePatch = ''
    substituteInPlace libgweather/Makefile.in --replace "\$(DESTDIR)\$(vapidir)" "\$(DESTDIR)\$(girdir)/../vala/vapi"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
