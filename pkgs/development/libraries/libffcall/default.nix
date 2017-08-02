{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libffcall-${version}";
  version = "1.10";

  src = fetchurl {
    urls = [
      # Europe
      "http://www.haible.de/bruno/gnu/ffcall-${version}.tar.gz"
      # USA
      "ftp://ftp.santafe.edu/pub/gnu/ffcall-${version}.tar.gz"
    ];
    sha256 = "0gcqljx4f8wrq59y13zzigwzaxdrz3jf9cbzcd8h0b2br27mn6vg";
  };

  NIX_CFLAGS_COMPILE = "-Wa,--noexecstack";

  configureFlags = [
    "--enable-shared"
    "--disable-static"
  ];

  meta = {
    description = "Foreign function call library";
    homepage = https://www.haible.de/bruno/packages-ffcall.html;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
