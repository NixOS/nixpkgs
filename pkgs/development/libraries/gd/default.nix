{ stdenv
, fetchFromGitHub
, pkgconfig
, zlib
, libpng
, libjpeg ? null
, libwebp ? null
, libtiff ? null
, libXpm ? null
, fontconfig
, freetype
, autoreconfHook
, perl
}:

stdenv.mkDerivation rec {
  name = "gd-${version}";
  version = "2016-06-10";

  # TODO: Remove this and use normal release when
  # next version is released (> 2.2.1).
  # This is required for below issue: 
  #   https://github.com/libgd/libgd/issues/214
  src = fetchFromGitHub {
      owner = "libgd";
      repo = "libgd";
      rev = "502e4cd873c3b37b307b9f450ef827d40916c3d6";
      sha256 = "14yihsas81r0bh1y4gcxiad4s22w8npr84hp56b7b2a9qazb4d9p";
  };
 
  nativeBuildInputs = [ pkgconfig autoreconfHook perl ];
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
