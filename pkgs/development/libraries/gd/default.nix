{ stdenv, fetchurl, fetchpatch
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
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/${pname}-${version}/libgd-${version}.tar.xz";
    sha256 = "0n5czhxzinvjvmhkf5l9fwjdx5ip69k5k7pj6zwb6zs1k9dibngc";
  };

  hardeningDisable = [ "format" ];
  patches = [
    # Fixes an issue where some other packages would fail to build
    # their documentation with an error like:
    # "Error: Problem doing text layout"
    #
    # Can be removed if Wayland can still be built successfully with
    # documentation.
    (fetchpatch {
      url = "https://github.com/libgd/libgd/commit/3dd0e308cbd2c24fde2fc9e9b707181252a2de95.patch";
      excludes = [ "tests/gdimagestringft/.gitignore" ];
      sha256 = "12iqlanl9czig9d7c3rvizrigw2iacimnmimfcny392dv9iazhl1";
    })
  ];

  # -pthread gets passed to clang, causing warnings
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--enable-werror=no";

  nativeBuildInputs = [ autoconf automake pkg-config ];

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
