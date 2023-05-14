{lib, stdenv, fetchurl, pkg-config, m4}:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "1.2.7";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/1.2/libsigc++-${version}.tar.bz2";
    sha256 = "099224v5y0y1ggqrfc8vga8afr3nb93iicn7cj8xxgsrwa83s5nr";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ m4];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "A typesafe callback system for standard C++";
    branch = "1.2";
    platforms = platforms.unix;
    license = licenses.lgpl3;
  };
}
