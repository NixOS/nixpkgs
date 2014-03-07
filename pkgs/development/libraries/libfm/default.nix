{ stdenv, fetchurl, glib, gtk, intltool, menu-cache, pango, pkgconfig, vala }:

stdenv.mkDerivation {
  name = "libfm-1.2.0";
  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/libfm-1.2.0.tar.xz";
    sha256 = "08pwdrmfm9rl41lj2niyjqq2bdvydxk7v2shjxh5gk1xwj238lgh";
  };

  buildInputs = [ glib gtk intltool menu-cache pango pkgconfig vala ];

  meta = with stdenv.lib; {
    homepage = "http://blog.lxde.org/?cat=28/";
    license = licenses.gpl2Plus;
    description = "A glib-based library for file management";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
  };
}
