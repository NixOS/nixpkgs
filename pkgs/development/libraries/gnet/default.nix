{stdenv, fetchFromGitHub, pkgconfig, autoconf, automake, glib, libtool }:

stdenv.mkDerivation {
  name = "gnet-2.0.8";
  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "gnet";
    rev = "GNET_2_0_8";
    sha256 = "1cy78kglzi235md964ikvm0rg801bx0yk9ya8zavndjnaarzqq87";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake glib libtool ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "A network library, written in C, object-oriented, and built upon GLib";
    homepage = https://developer.gnome.org/gnet/;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
