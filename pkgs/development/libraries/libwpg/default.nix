{ lib, stdenv, fetchurl, pkg-config, libwpd, zlib, librevenge }:

stdenv.mkDerivation rec {
  pname = "libwpg";
  version = "0.3.3";

  src = fetchurl {
    url = "mirror://sourceforge/libwpg/${pname}-${version}.tar.xz";
    sha256 = "074x159immf139szkswv2zapnq75p7xk10dbha2p9193hgwggcwr";
  };

  buildInputs = [ libwpd zlib librevenge ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://libwpg.sourceforge.net";
    description = "C++ library to parse WPG";
    license = with licenses; [ lgpl21 mpl20 ];
    platforms = platforms.all;
  };
}
