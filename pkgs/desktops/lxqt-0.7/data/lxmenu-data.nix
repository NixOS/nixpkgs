{ stdenv, fetchgit
, automake, autoconf, libtool
, glib, intltool
}:

stdenv.mkDerivation rec {
  basename = "lxmenu-data";
  version = "0.1.4";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "4a2342616c5cc2a089256ebb64e763ff7cb0d5a6";
    sha256 = "90def64f86c97c2954914c621aee392e14bda1cfb0ae300dc95200455981ca45";
  };

  buildInputs = [ stdenv automake autoconf libtool glib intltool ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Data files for application menu";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
