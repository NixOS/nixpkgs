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
  version = "2.2.3";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/${name}/libgd-${version}.tar.xz";
    sha256 = "0g3xz8jpz1pl2zzmssglrpa9nxiaa7rmcmvgpbrjz8k9cyynqsvl";
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
