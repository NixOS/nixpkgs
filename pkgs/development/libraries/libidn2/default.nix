{ fetchurl, stdenv, libiconv, libunistring, help2man }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libidn2-0.16";

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/libidn/${name}.tar.gz";
    sha256 = "13v8kh4d5nfkymai88zlw3h7k4x9khrpdpv97waf4ah8ykzrxb9g";
  };

  outputs = [ "bin" "dev" "out" "info" "devdoc" ];

  patches = optional stdenv.isDarwin ./fix-error-darwin.patch;

  buildInputs = [ libunistring ]
    ++ optionals stdenv.isDarwin [ libiconv help2man ];

  meta = {
    homepage = "https://www.gnu.org/software/libidn/#libidn2";
    description = "Free software implementation of IDNA2008 and TR46";

    longDescription = ''
      Libidn2 is believed to be a complete IDNA2008 and TR46 implementation,
      but has yet to be as extensively used as the IDNA2003 Libidn library.

      The installed C library libidn2 is dual-licensed under LGPLv3+|GPLv2+,
      while the rest of the package is GPLv3+.  See the file COPYING for
      detailed information.
    '';

    repositories.git = https://gitlab.com/jas/libidn2;
    license = with stdenv.lib.licenses; [ lgpl3Plus gpl2Plus gpl3Plus ];
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ fpletz ];
  };
}
