{ lib
, stdenv
, fetchurl
, imlib2
, libX11
, libXext
, ncurses
, pkg-config
, x11Support ? !stdenv.isDarwin
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libcaca";
  version = "0.99.beta19";

  src = fetchurl {
    urls = [
      "http://fossies.org/linux/privat/${pname}-${version}.tar.gz"
      "http://caca.zoy.org/files/libcaca/${pname}-${version}.tar.gz"
    ];
    hash = "sha256-EotGfE7QMmTBh0BRcqToMEk0LMjML2VfU6LQ7p03cvQ=";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  configureFlags = [
    (if x11Support then "--enable-x11" else "--disable-x11")
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString (!x11Support) "-DX_DISPLAY_MISSING";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    ncurses
    zlib
    (imlib2.override { inherit x11Support; })
  ] ++ lib.optionals x11Support [
    libX11
    libXext
  ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/caca-config $dev/bin/caca-config
  '';

  meta = with lib; {
    homepage = "http://caca.zoy.org/wiki/libcaca";
    description = "A graphics library that outputs text instead of pixels";
    longDescription = ''
      libcaca is a graphics library that outputs text instead of pixels, so that
      it can work on older video cards or text terminals. It is not unlike the
      famous ​AAlib library, with the following improvements:

      - Unicode support
      - 2048 available colours (some devices can only handle 16)
      - dithering of colour images
      - advanced text canvas operations (blitting, rotations)

      Libcaca works in a text terminal (and should thus work on all Unix systems
      including Mac OS X) using the S-Lang or ncurses libraries. It also works
      natively on DOS and Windows.

      Libcaca was written by Sam Hocevar and Jean-Yves Lamoureux.
    '';
    license = licenses.wtfpl;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
