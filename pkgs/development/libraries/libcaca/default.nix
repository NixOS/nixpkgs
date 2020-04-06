{ stdenv, fetchurl, ncurses, zlib, pkgconfig, imlib2
, x11Support ? !stdenv.isDarwin, libX11, libXext
}:

stdenv.mkDerivation rec {
  name = "libcaca-0.99.beta19";

  src = fetchurl {
    urls = [
      "http://fossies.org/linux/privat/${name}.tar.gz"
      "http://caca.zoy.org/files/libcaca/${name}.tar.gz"
    ];
    sha256 = "1x3j6yfyxl52adgnabycr0n38j9hx2j74la0hz0n8cnh9ry4d2qj";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  configureFlags = [
    (if x11Support then "--enable-x11" else "--disable-x11")
    ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (!x11Support) "-DX_DISPLAY_MISSING";

  enableParallelBuilding = true;

  propagatedBuildInputs = [ ncurses zlib pkgconfig (imlib2.override { inherit x11Support; }) ]
    ++ stdenv.lib.optionals x11Support [ libX11 libXext ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/caca-config $dev/bin/caca-config
  '';

  meta = {
    homepage = http://libcaca.zoy.org/;
    description = "A graphics library that outputs text instead of pixels";
    license = stdenv.lib.licenses.wtfpl;
    platforms = stdenv.lib.platforms.unix;
  };
}
