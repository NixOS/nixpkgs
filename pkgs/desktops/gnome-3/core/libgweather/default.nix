{ stdenv, fetchurl, pkgconfig, libxml2, gtk, intltool, libsoup, gconf
, pango, gdk_pixbuf, atk, tzdata, gnome3 }:

stdenv.mkDerivation rec {
  name = "libgweather-${version}";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libgweather/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "fca78470b345bce948e0333cab0a7c52c32562fc4a75de37061248a64e8fc4b8";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "libgweather"; attrPath = "gnome3.libgweather"; };
  };

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
