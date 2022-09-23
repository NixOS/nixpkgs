{ lib, stdenv, fetchurl, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "libHX";
  version = "3.22";

  src = fetchurl {
    url = "mirror://sourceforge/libhx/libHX/${version}/${pname}-${version}.tar.xz";
    sha256 = "18w39j528lyg2026dr11f2xxxphy91cg870nx182wbd8cjlqf86c";
  };

  patches = [];

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ libtool ];

  preConfigure = ''
    sh autogen.sh
    '';

  meta = with lib; {
    homepage = "http://libhx.sourceforge.net/";
    longDescription = ''
      libHX is a C library (with some C++ bindings available) that provides data structures
      and functions commonly needed, such as maps, deques, linked lists, string formatting
      and autoresizing, option and config file parsing, type checking casts and more.
      '';
    maintainers = [ ];
    platforms = platforms.linux;
    license = with licenses; [ gpl3 lgpl21Plus wtfpl ];
  };
}
