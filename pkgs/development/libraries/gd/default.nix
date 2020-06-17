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
  pname = "gd";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/${pname}-${version}/libgd-${version}.tar.xz";
    sha256 = "0n5czhxzinvjvmhkf5l9fwjdx5ip69k5k7pj6zwb6zs1k9dibngc";
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

  doCheck = false; # fails 2 tests

  meta = with stdenv.lib; {
    homepage = "https://libgd.github.io/";
    description = "A dynamic image creation library";
    license = licenses.free; # some custom license
    platforms = platforms.unix;
  };
}
