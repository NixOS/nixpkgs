{ stdenv, fetchurl, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "libHX-3.22";

  src = fetchurl {
    url = "mirror://sourceforge/libhx/libHX/3.22/${name}.tar.xz";
    sha256 = "18w39j528lyg2026dr11f2xxxphy91cg870nx182wbd8cjlqf86c";
  };

  patches = [];

  buildInputs = [ autoconf automake libtool ];

  preConfigure = ''
    sh autogen.sh
    '';

  meta = {
    homepage = http://libhx.sourceforge.net/;
    longDescription = ''
      libHX is a C library (with some C++ bindings available) that provides data structures
      and functions commonly needed, such as maps, deques, linked lists, string formatting
      and autoresizing, option and config file parsing, type checking casts and more.
      '';
    maintainers = [ stdenv.lib.maintainers.tstrobel ];
    platforms = stdenv.lib.platforms.linux;
  };
}
