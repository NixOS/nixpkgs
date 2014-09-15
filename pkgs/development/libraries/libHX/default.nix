{ stdenv, fetchurl, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "libHX-3.21";

  src = fetchurl {
    url = "mirror://sourceforge/libhx/libHX/3.21/${name}.tar.xz";
    sha256 = "0wcr6kbhsw6v4js7q4p7fhli37c39dv1rryjf768rkwshl2z8f6v";
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
