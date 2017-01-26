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
}:

stdenv.mkDerivation rec {
  name = "gd-${version}";
  version = "2.2.4";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/${name}/libgd-${version}.tar.xz";
    sha256 = "1rp4v7n1dq38b92kl7gkvpvqqkw7nvdfnz6d5kip5klkxfki6zqk";
  };

  hardeningDisable = [ "format" ];

  # -pthread gets passed to clang, causing warnings
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--enable-werror=no";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ zlib fontconfig freetype ];
  propagatedBuildInputs = [ libpng libjpeg libwebp libtiff libXpm ];

  outputs = [ "bin" "dev" "out" ];

  postFixup = ''moveToOutput "bin/gdlib-config" $dev'';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://libgd.github.io/;
    description = "A dynamic image creation library";
    license = licenses.free; # some custom license
    platforms = platforms.unix;
  };
}
