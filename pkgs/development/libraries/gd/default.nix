{ lib, stdenv, fetchurl, fetchpatch
, autoconf
, automake
, pkg-config
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
  version = "2.3.2";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/${pname}-${version}/libgd-${version}.tar.xz";
    sha256 = "1yypywkh8vphcy4qqpf51kxpb0a3r7rjqk3fc61rpn70hiq092j7";
  };

  hardeningDisable = [ "format" ];
  patches = [
    (fetchpatch {
      name = "CVE-2021-40812.partial.patch";
      url = "https://github.com/libgd/libgd/commit/6f5136821be86e7068fcdf651ae9420b5d42e9a9.patch";
      sha256 = "11rvhd23bl05ksj8z39hwrhqqjm66svr4hl3y230wrc64rvnd2d2";
    })
  ];

  # -pthread gets passed to clang, causing warnings
  configureFlags = lib.optional stdenv.isDarwin "--enable-werror=no";

  nativeBuildInputs = [ autoconf automake pkg-config ];

  buildInputs = [ zlib fontconfig freetype ];
  propagatedBuildInputs = [ libpng libjpeg libwebp libtiff libXpm ];

  outputs = [ "bin" "dev" "out" ];

  postFixup = ''moveToOutput "bin/gdlib-config" $dev'';

  enableParallelBuilding = true;

  doCheck = false; # fails 2 tests

  meta = with lib; {
    homepage = "https://libgd.github.io/";
    description = "A dynamic image creation library";
    license = licenses.free; # some custom license
    platforms = platforms.unix;
  };
}
