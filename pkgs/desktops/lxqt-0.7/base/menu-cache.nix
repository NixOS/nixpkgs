{ stdenv, fetchgit, pkgconfig
, automake, autoconf, libtool
, gtk_doc
, glib
, libfm
}:

stdenv.mkDerivation rec {
  basename = "menu-cache";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "d6cc1d6c10e841f74f24710a96c0ed6d7baf364a";
    sha256 = "34cbcfcad2f40766ea308a7884d6ccbeca6a8c8c192d65b58abbd6a0ca16d388";
  };

  buildInputs = [ stdenv pkgconfig automake autoconf libtool gtk_doc glib libfm ];

  # For some reason, libfm doesn't produce pkgconfig/libfm-extra.pm, so we need to set the LIBFM flags explicitly here
  preConfigure = ''
    export LIBFM_EXTRA_CFLAGS="-I${libfm}/include"
    export LIBFM_EXTRA_LIBS="-L${libfm}/lib -lfm-extra"
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
