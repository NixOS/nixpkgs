{ stdenv, fetchgit, pkgconfig
, automake, autoconf, libtool
, gtk_doc
, glib
, lxqt-libfm-extras
}:

stdenv.mkDerivation rec {
  basename = "menu-cache";
  version = "1.0.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "1ee5180c51ed5f9ce4ff65d9ddc3eefb6b7e2db0";
    sha256 = "87b937e20a9af4225b8bb7f07cb1a12b17e3291da00ab63f3ae0f17f53356c3a";
  };

  buildInputs = [ stdenv pkgconfig automake autoconf libtool gtk_doc glib lxqt-libfm-extras ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Library used to read freedesktop.org menus";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
