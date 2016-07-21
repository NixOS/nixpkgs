{ stdenv, fetchurl
, pkgconfig
, zlib
, libpng
, libjpeg ? null
, libwebp ? null
, libtiff ? null
, libXpm ? null
, fontconfig
, freetype
, fetchpatch, autoreconfHook, perl
}:

stdenv.mkDerivation rec {
  name = "gd-${version}";
  version = "2.2.2";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/${name}/libgd-${version}.tar.xz";
    sha256 = "1311g5mva2xlzqv3rjqjc4jjkn5lzls4skvr395h633zw1n7b7s8";
  };

  hardeningDisable = [ "format" ];

  # Address an incompatibility with Darwin's libtool
  patches = stdenv.lib.optional stdenv.isDarwin (fetchpatch {
    url = https://github.com/libgd/libgd/commit/502e4cd873c3b37b307b9f450ef827d40916c3d6.patch;
    sha256 = "0gawr2c4zr6cljnwzhdlxhz2mkbg0r5vzvr79dv6yf6fcj06awfs";
  });

  # -pthread gets passed to clang, causing warnings
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--enable-werror=no";

  nativeBuildInputs = [ pkgconfig ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ autoreconfHook perl ];

  buildInputs = [ zlib fontconfig freetype ];
  propagatedBuildInputs = [ libpng libjpeg libwebp libtiff libXpm ];

  outputs = [ "dev" "out" "bin" ];

  postFixup = ''moveToOutput "bin/gdlib-config" $dev'';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://libgd.github.io/;
    description = "A dynamic image creation library";
    license = licenses.free; # some custom license
    platforms = platforms.unix;
  };
}
