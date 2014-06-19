{ stdenv, fetchurl, pkgconfig, glib, autoconf, automake, libtool, intltool }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-dev-tools";
  ver_maj = "4.10";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1y1byfjciqhxqfxbjfp22bn5lxk3a01ng7zfjha8h5mzzfxlk5pp";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig glib ];

  # not needed to build it but to use it
  propagatedBuildInputs = [ autoconf automake libtool intltool ];

  meta = {
    homepage = http://foo-projects.org/~benny/projects/xfce4-dev-tools/;
    description = "Tools and M4 macros for Xfce4 developers";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
