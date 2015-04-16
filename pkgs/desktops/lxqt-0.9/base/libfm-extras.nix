{ stdenv, fetchgit, pkgconfig
, automake, autoconf, libtool
, gtk_doc, intltool, glib
, which
}:

stdenv.mkDerivation rec {
  basename = "lxqt-libfm-extras";
  version = "1.2.3";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/libfm.git";
    rev = "f3442a330bb6aea5d9246e61da5911e75793db7f";
    sha256 = "349494252401766dd0ada85f148eaa9a021338da4e0e0b21a63458ed73ea2fd9";
  };

  buildInputs = [ stdenv pkgconfig automake autoconf libtool gtk_doc intltool glib which ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = ''--without-gtk --disable-demo --with-extra-only'';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Library used to read freedesktop.org menus";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
