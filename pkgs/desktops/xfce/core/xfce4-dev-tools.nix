{ stdenv, fetchurl, pkgconfig, glib, autoconf, automake, libtool, intltool }:
let
  p_name  = "xfce4-dev-tools";
  ver_maj = "4.12";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1jxmyp80pwbfgmqmwpjxs7z5dmm6pyf3qj62z20xy44izraadqz2";
  };

  buildInputs = [ pkgconfig glib ];

  # not needed to build it but to use it
  propagatedBuildInputs = [ autoconf automake libtool intltool ];

  meta = {
    homepage = http://foo-projects.org/~benny/projects/xfce4-dev-tools/;
    description = "Tools and M4 macros for Xfce4 developers";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}

